setwd("C:/Users/paul-gilloteaux-p/Documents/GitHub/ANRCROCOVAL/misc_analysis_tools/histologicalslides/BleuAlcyan/test")
#file.choose()
# Install the released version from CRAN:
#install.packages("stringr")
#install.packages("zoo")
library("stringr")
library("zoo") #maybe to use rollmean
listfile=dir()

i=0
data=NULL
first<-1;
for (n in listfile)
{
	
	
	if (grepl("Absolutewidth.csv", n)==TRUE)
	{
		print(n)
		datW <-read.csv(n, sep=",")
		AUCred=sum(datW$storewidthum[-1])
		#print(100*AUCred/length(datW$storewidthum[-1]))
		#print(AUCred)
		a<-datW$storewidthum[-1]
		b<-datW$storenormalizedpos[-1]
		wtiers1<-100*sum(a[b<=(1/3)])/length(b)
		wtiers2<-100*sum(a[b>(1/3)&b<=(2/3)])/length(b)
		wtiers3<-100*sum(a[b>(2/3)])/length(b)

		print(wtiers1)
		print(wtiers2)
		print(wtiers3)



		n=str_replace(n, "Absolutewidth.csv", "AbsoluteBA.csv")
		print(n)
		datBA <-read.csv(n, sep=",")
		AUCgreen=sum(datBA$storeBApc[-1]*datW$storewidthum[-1])
		print(100*AUCgreen/length(datBA$storeBApc[-1]))

		print(AUCgreen)
		#print(100*(100*AUCgreen/length(datBA$storeBApc[-1]))/(100*AUCred/length(datW$storewidthum[-1])))

		print(AUCgreen/AUCred*100)
		b<-datBA$storenormalizedposBA[-1]
		a<-datBA$storeBApc[-1]*datW$storewidthum[-1]

		btiers1<-100*sum(a[b<=(1/3)])/length(b)
		btiers2<-100*sum(a[b>(1/3)&b<=(2/3)])/length(b)
		btiers3<-100*sum(a[b>(2/3)])/length(b)

		print(btiers1)
		print(btiers2)
		print(btiers3)
		print(100*btiers1/wtiers1)
		print(100*btiers2/wtiers2)
		print(100*btiers3/wtiers3)
		if(first==1){
			finaltab<-data.frame(Image=n,AUCred_normalized=100*AUCred/length(datW$storewidthum[-1]), AUCgreen_normalized=100*AUCgreen/length(datBA$storeBApc[-1]),width_tiers1=wtiers1,width_tiers2=wtiers2, width_tiers3=wtiers3,BA_tiers1=btiers1,BA_tiers2=btiers2,BA_tiers3=btiers3)

			first<-0
		}
		else{
		tableau<-data.frame(Image=n,AUCred_normalized=100*AUCred/length(datW$storewidthum[-1]), AUCgreen_normalized=100*AUCgreen/length(datBA$storeBApc[-1]),width_tiers1=wtiers1,width_tiers2=wtiers2, width_tiers3=wtiers3,BA_tiers1=btiers1,BA_tiers2=btiers2,BA_tiers3=btiers3)

	
		finaltab<-rbind(finaltab,tableau)}
		

								
	}

}
write.csv(finaltab,"resultAUCNew.csv", row.names=FALSE)

