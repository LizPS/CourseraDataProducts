#set values for testing this graphing function
        #library(ggplot2)
        #library(reshape2)
        #library(scales)
        #tdat <- read.table("thyroid.txt", sep=",",stringsAsFactors=FALSE, header=TRUE)


#wrap all the manip and graphing into a function call that server.R can use
               
 t_graph <- function(tdat, showtx, treatdate=as.Date("2012-01-01")){
        datedf <- data.frame(treatdate) #put treatdate in df so ggplot can find it!

        #Sub-functions to standardize test values
        stdTSH <-function(x) {
                sTSH <- (x-2.95)/1.275
                if (is.na(x)){
                    return(NA)
                }else{return(sTSH)}
        } 
        stdT3 <-function(x) {
                sT3 <- (x-3.2)/0.7
                if (is.na(x)){
                    return(NA)
                }else{return(sT3)}
        }
        stdT4 <-function(x) {
                sT4 <- (x-1.25)/.275
                if (is.na(x)){
                    return(NA)
                }else{return(sT4)}
        } 
        #Convert date column back to date (stored as char to avoid xtables problem)
        tdat$Date <- as.Date(tdat$Date, format="%Y-%m-%d")
        
        #Standardize test scores and add to dataframe
        tdat$sTSH <- sapply(tdat$TSH,stdTSH)
        tdat$sT3 <- sapply(tdat$FreeT3, stdT3)
        tdat$sT4 <- sapply(tdat$FreeT4, stdT4)
        
        #Melt dataframe to prepare for graphing and rename columns
        longtdat <- melt(tdat[, c(1,5:7)], id.vars=c("Date"))
        names(longtdat)[2] <- "Test"
        names(longtdat)[3] <- "Result"
        
        #construct base graph (not showing Tx date)
        thyplot <- ggplot(longtdat, aes(x=Date, y=Result, 
                color = factor(Test, 
                labels = c("TSH","T3","T4")))) + 
                scale_color_manual(values= c("#7b3294","#c2a5cf","#008837" )) +
                geom_rect(xmin=0, xmax=Inf, ymin=-2, ymax=2, fill = "#a6dba0", 
                        alpha = 0.01, linetype = 0) +
                geom_point(size = 4, na.rm=TRUE) +
                scale_x_date(labels = date_format("%b %Y")) +
                labs(color="Test Type", title="Your Test Results") +
                scale_y_continuous(breaks=c(-2,0,2,4),
                        labels=c("low average","average","high average","high"),
                        name="", limits = c(-2.5, 4.5)) +
                geom_line(size = 1.5)
        
        if (showtx == 0){
                return(thyplot)
                } else {
                return(thyplot+
                geom_vline(data=datedf, aes(xintercept=as.numeric(treatdate)), 
                        color="#a6dba0", size=1.5, linetype="dashed") +
                geom_text(data=datedf, aes(x = treatdate, 
                        label="\nTreatment Begun", y=1), colour="#a6dba0",
                        angle=90, text=element_text(size=11))) 
        }
}
