
#install.packages("ks")
#install.packages("corrplot")
library("ks")
library("corrplot")
## p value > 0.05 accept H0: f1=f2

## pvalue < 0.05 reject H0: f1=f2

nomsfichiers=list.files("C:/Users/perri/GITHUB/misc_analysis_tools/histologicalslides/data/Analyse_Maps/",recursive= TRUE, pattern
= "*.csv") 
nbfiles=length(nomsfichiers)
M <-as.data.frame(matrix(ncol=nbfiles, nrow=nbfiles),row.names=nomsfichiers)

M[is.na(M)] <- 0
 colnames(M)<-nomsfichiers
i=0
j=0
for (nom in nomsfichiers) {
	i=i+1
	j=0
	for (nom2 in nomsfichiers){
	j=j+1
		input1 <-file.path("C:/Users/perri/GITHUB/misc_analysis_tools/histologicalslides/data/Analyse_Maps", nom)
		nucleidata <- read.csv(input1,header= TRUE,sep=";")
		yn<-nucleidata[,1]
		xn<-nucleidata[,2]
		coordinates<-c(xn,yn)
		dim(coordinates)<-c( NROW(xn),2)
		#plot(coordinates)

		input2 <-file.path("C:/Users/perri/GITHUB/misc_analysis_tools/histologicalslides/data/Analyse_Maps/", nom2)
		nucleidata <- read.csv(input2,header= TRUE,sep=";")
		yn<-nucleidata[,1]
		xn<-nucleidata[,2]
		coordinates2<-c(xn,yn)
		dim(coordinates2)<-c( NROW(xn),2)
		#plot(coordinates2)
		print(input1)
		print(input2)
		M
		print(kde.test(x1=coordinates, x2=coordinates2)$pvalue)
		M[i,j]<-kde.test(x1=coordinates, x2=coordinates2)$pvalue	
	
	}
}  
Mdata=data.matrix(M)   
col3 <- colorRampPalette(c("red", "yellow", "blue"))      
corrplot(Mdata, is.corr=FALSE, method="color",col = col3(100))
corrplot(Mdata, is.corr=FALSE, method="number")
corrplot(Mdata, is.corr=FALSE, method="color", order="hclust")
 write.csv(M,"C:/Users/perri/GITHUB/misc_analysis_tools/histologicalslides/exportdensitymaptest.csv")