
#install.packages("ks")

library("ks")
set.seed(8192)
samp <- 1000
x <- rnorm.mixt(n=samp, mus=0, sigmas=1, props=1)
y <- rnorm.mixt(n=samp, mus=0, sigmas=1, props=1)
kde.test(x1=x, x2=y)$pvalue ## accept H0: f1=f2

library(MASS)
data(crabs)
x1 <- crabs[crabs$sp=="B", c(4,6)]
x2 <- crabs[crabs$sp=="O", c(4,6)]
kde.test(x1=x1, x2=x2)$pvalue ## reject H0: f1=f2

nomsfichiers=list.files("C:/Users/perri/GITHUB/misc_analysis_tools/histologicalslides/data/Analyse_Maps/") 
     
input <-"C:/Users/perri/GITHUB/misc_analysis_tools/histologicalslides/data/Analyse_Maps/3W_WT/493_3W_ant.csv"
nucleidata <- read.csv(input,header= TRUE,sep=";")
yn<-nucleidata[,1]
xn<-nucleidata[,2]
coordinates<-c(xn,yn)
dim(coordinates)<-c( NROW(xn),2)
plot(coordinates)

input <-"C:/Users/perri/GITHUB/misc_analysis_tools/histologicalslides/data/Analyse_Maps/3W_KI/510_3W_ant.csv"
nucleidata <- read.csv(input,header= TRUE,sep=";")
yn<-nucleidata[,1]
xn<-nucleidata[,2]
coordinates2<-c(xn,yn)
dim(coordinates2)<-c( NROW(xn),2)
plot(coordinates2)

kde.test(x1=coordinates, x2=coordinates2)$pvalue