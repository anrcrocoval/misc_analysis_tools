
install.packages("KernSmooth")
install.packages("raster")
library("KernSmooth")
library("raster")
input <- "D:/Romain/FLNA331_316WHPS_1.tif_Results.csv"
nucleidata <- read.csv(input)
yn<-nucleidata[,14]
xn<-nucleidata[,8]
coordinates<-c(xn,yn)
dim(coordinates)<-c( NROW(xn),2)
est <- bkde2D(coordinates, 
bandwidth=c(0.05,0.05),
gridsize=c(1000,1000),
range.x=list(c(0,1),c(0,1)))

est.raster = raster(list(x=est$x1,y=est$x2,z=est$fhat))

plot(est.raster)

ynr<-nucleidata[,13]
xnr<-nucleidata[,6]
coordinates<-c(xnr,ynr)
dim(coordinates)<-c( NROW(xnr),2)
est <- bkde2D(coordinates, 
bandwidth=c(20,20),
gridsize=c(1000,1000),
range.x=list(c(0,2000),c(0,200)))

est.raster = raster(list(x=est$x1,y=est$x2,z=est$fhat))
#xmin(est.raster) <- 0
#xmax(est.raster) <- 2000
#ymin(est.raster) <- 0
#ymax(est.raster) <- 200
dev.new()
plot(est.raster)

ynp<-nucleidata[,3]
xnp<-nucleidata[,2]
coordinates<-c(xnp,ynp)
dim(coordinates)<-c( NROW(xnp),2)
est <- bkde2D(coordinates, 
bandwidth=c(20,20),
gridsize=c(1000,1000),
range.x=list(c(0,2000),c(0,2000)))

est.raster = raster(list(x=est$x1,y=est$x2,z=est$fhat))
#xmin(est.raster) <- 0
#xmax(est.raster) <- 2000
#ymin(est.raster) <- 0
#ymax(est.raster) <- 200
dev.new()
plot(est.raster)