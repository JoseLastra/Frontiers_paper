# Function: calculating the seasonal snow probability
SnowAucRocMap <-
  function(s,dates,nCluster,outname,format,datatype) {
    ff <- function(x) {
      options(warn=-1)
      # a.Preparing dataset
      
      if (all(is.na(x))) {
        return(rep(NA,1))
      }
      
      # Arranging dates per season
      x <- round(x) # makes FLOAT values INTEGER, in case rasters are not INTEGER
      x[sapply(x, is.null)] <- NA #Conversion null value to NA
      data<-as.data.frame(cbind(x))
      
      data$doy <- yday(dates)
      data$month <- as.numeric(format(dates, "%m"))
      
      #----------------------------------------------------------------------------------------
      # Making seasonal data
      data$season <- data$month
      #Summer=100
      data$season[data$month==12]<-100
      data$season[data$month==1] <-100
      data$season[data$month==2] <-100
      #Autumn=200
      data$season[data$month==3] <-200
      data$season[data$month==4] <-200
      data$season[data$month==5] <-200
      #Winter=300
      data$season[data$month==6] <-300
      data$season[data$month==7] <-300
      data$season[data$month==8] <-300
      #Spring=400
      data$season[data$month==9]  <-400
      data$season[data$month==10] <-400
      data$season[data$month==11] <-400
      
      data2<-as.data.frame(cbind(data$season,x))
      data2 <- na.omit(data2)
      colnames(data2)<-c("season","snow")
      data2$season <- factor(data2$season)
      #----------------------------------------------------------------------------------------
      # glm to calculate prob of having snow at a given season
      # for output interpretation visit http://www.ats.ucla.edu/stat/r/dae/logit.htm
  
      sn1<-glm(snow ~ season, data=data2, family=binomial)

      
      p <- predict(sn1, type = "response") # calculates on training data
      
      if(length(unique(data2$snow)) > 1) {
        roc.pred <- prediction(p, data2$snow)
        auc <- performance(roc.pred, measure = "auc")
        auc.val <- auc@y.values[[1]]
      } else {
        if(identical(unique(data2$snow),1)) {auc.val<-9}
        if(identical(unique(data2$snow),0)) {auc.val<-8}
      }
      auc.val <- round(auc.val*10000)
      auc.val[1]
    }
    
    #----------------------------------------------------------------------------------------
    # Calculating the annual phenological curve using n clusters
    beginCluster(n=nCluster) # write 'beginCluster(n=3)' for using e.g. 3 cores, default uses all available cores)
    dates <<- dates
    clusterR(x=s,calc, args=list(ff),export=c('dates'),filename=outname,format=format,datatype=datatype,overwrite=T)
    endCluster()
  }
