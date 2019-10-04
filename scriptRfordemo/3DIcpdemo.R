require(Morpho) #https://cran.r-project.org/web/packages/Morpho/Morpho.pdf
data(nose)

source.lm<- longnose.lm

target.lm <- rotaxis3d(longnose.lm,pt1=c(1,1,1),theta=pi/3) +50
require(rgl)
myradius=1.5
rgl.open()
require(Rvcg)
rgl.bg(col="#cccccc")
rgl.spheres(source.lm,color="gray",radius=myradius,specular="green",texture=system.file("textures/bump_dust.png",package="rgl"),texmipmap=T, texminfilter="linear.mipmap.linear")
rgl.spheres(target.lm,color="gray",radius=myradius,specular="red",texture=system.file("textures/bump_dust.png",package="rgl"),texmipmap=T, texminfilter="linear.mipmap.linear")
i=0
title=paste("C:/Users/perri/OneDrive/Images/dataset17/image",i,sep="")
     title=paste(title,".png",sep="")



readline(prompt="press Enter ")
#rgl.snapshot(title)

for (i in 1:30) 
{
	rgl.clear()
	#rgl.spheres(source.lm ,color="gray",radius=myradius,specular="green",texture=system.file("textures/bump_dust.png",package="rgl"),texmipmap=T, texminfilter="linear.mipmap.linear")
	rgl.spheres(target.lm,color="gray",radius=myradius,specular="red",texture=system.file("textures/bump_dust.png",package="rgl"),texmipmap=T, texminfilter="linear.mipmap.linear")

	icp <- icpmat(source.lm,target.lm,iterations=i,type="rigid")
	rgl.spheres(icp,color="gray",radius=myradius,specular="blue",texture=system.file("textures/bump_dust.png",package="rgl"),texmipmap=T, texminfilter="linear.mipmap.linear")
	RMSE <- sqrt(sum(vcgKDtree(target.lm,icp[,],k=1)$distance^2)) 

	
     title=paste("C:/Users/perri/OneDrive/Images/dataset17/plot",i,sep="")
     title=paste(title,".png",sep="")

	#rgl.snapshot(title)
	par(new = TRUE)
	plot(i,RMSE,xlim=c(0,30),ylim=c(0,400),pch=20)
	#dev.copy(png,filename=title);
      #dev.off ();
	#readline(prompt="press Enter ")
}

