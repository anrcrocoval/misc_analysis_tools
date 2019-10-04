require(splines)
nbpoints<-20
x<-stats::runif(nbpoints)*100
xo<-10*stats::rnorm(nbpoints)+x;
y<-3*x+50
yo<-50*stats::rnorm(nbpoints)+y
fittrue<-lm(y~x)
fito<-lm(yo~x)


#polygon(c(x,rev(x)),c(16+2.54*x,rev(68+3.39*x)),border=NA,col=blues9[3])

par(new = TRUE)
plot(x,yo,xlim=c(0,100),ylim=c(0,500),pch=20)

par(new = TRUE)
plot(x,y,xlim=c(0,100),ylim=c(0,500),col="green",pch=20);

abline(fittrue,col="green",lwd=3)
abline(fito,col="red",lwd=3)

confint(fittrue)
confint(fito)


tnl<-nls(yo~a*x+b,start=list(a=5,b=30))
par(new = TRUE)
#plot(x,predict(tnl),col="green",xlim=c(0,100),ylim=c(0,500))
lines(x,predict(tnl),col="black")
par(new = TRUE)
fit1<-smooth.spline(x,yo,df=30)
lines(fit1,col="red",lwd=2)
fit1<-smooth.spline(x,yo,df=20)
plot(x,yo,xlim=c(0,100),ylim=c(0,500),pch=20)
abline(fittrue,col="green",lwd=3)

lines(predict(fit1,-5:105),col="red",lwd=2)

