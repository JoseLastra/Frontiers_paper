# Function: calculating the seasonal snow probability
SnowProbMap <-
  function(s,dates,nCluster,outname,format,datatype) {
    ff <- function(x) {
      
      # a.Preparing dataset
      
      if (all(is.na(x))) {
        return(rep(NA,4))
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
      colnames(data2)<-c("season","snow")
      data2 <- na.omit(data2)
      data2$season <- factor(data2$season)
      if(nrow(data2) <= 1){ #Ajuste realizado para exceso de NA's
  return(rep(NA,4))
}
      #----------------------------------------------------------------------------------------
      # glm to calculate prob of having snow at a given season
      # for output interpretation visit http://www.ats.ucla.edu/stat/r/dae/logit.htm
     
      sn1<-glm(snow ~ season, data=data2, family=binomial)
      
      #Summer
      x.sum <- subset(data2,season==100)
      if(all(is.na(x.sum$snow))) {p.sum <- NA} else {
        n.sum <- 100
        new.data.sum <-data.frame(season=n.sum)
        new.data.sum$season <- factor(new.data.sum$season)
        p.sum <- predict(sn1, newdata=new.data.sum, type = "response")
        p.sum <- round(as.numeric(p.sum)*10000)
      }
      
      #Autumn
      x.aut <- subset(data2,season==200)
      if(all(is.na(x.aut$snow))) {p.aut <- NA} else {
        n.aut <- 200
        new.data.aut <-data.frame(season=n.aut)
        new.data.aut$season <- factor(new.data.aut$season)
        p.aut <- predict(sn1, newdata=new.data.aut, type = "response")
        p.aut <- round(as.numeric(p.aut)*10000)
      }
      
      #Winter
      x.win <- subset(data2,season==300)
      if(all(is.na(x.win$snow))) {p.win <- NA} else {
        n.win <- 300
        new.data.win <-data.frame(season=n.win)
        new.data.win$season <- factor(new.data.win$season)
        p.win <- predict(sn1, newdata=new.data.win, type = "response")
        p.win <- round(as.numeric(p.win)*10000)
      }
      
      #Spring
      x.spr <- subset(data2,season==400)
      if(all(is.na(x.spr$snow))) {p.spr <- NA} else {
        n.spr <- 400
        new.data.spr <-data.frame(season=n.spr)
        new.data.spr$season <- factor(new.data.spr$season)
        p.spr <- predict(sn1, newdata=new.data.spr, type = "response")
        p.spr <- round(as.numeric(p.spr)*10000)
      }
      
      four.seas <- c(p.sum,p.aut,p.win,p.spr)
      four.seas[1:4]
    }
    
    #----------------------------------------------------------------------------------------
    # Calculating the annual phenological curve using n clusters
    beginCluster(n=nCluster) # write 'beginCluster(n=3)' for using e.g. 3 cores, default uses all available cores)
    dates <<- dates
    clusterR(x=s,calc, args=list(ff),export=c('dates'),filename=outname,format=format,datatype=datatype,overwrite=T)
    endCluster()
  }
