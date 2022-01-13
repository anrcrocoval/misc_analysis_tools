setwd("C:/Users/perri/GITHUB/misc_analysis_tools/histologicalslides/BleuAlcyan/test")
#file.choose()

listfile=dir()

i=0
data=NULL

for (n in listfile)
{
	
	
	if (grepl("Absolutewidth.csv", n)==TRUE)
	{
		print(n)
		dat <-read.csv(n, sep=",")
		plot(dat$storenormalizedpos[-1],dat$storewidthum[-1]) #plot all but first element
		readline(prompt="Press [enter] to continue")
		readline(prompt="Press [enter] to continue")


	}
}

