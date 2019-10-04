require(Morpho) #https://cran.r-project.org/web/packages/Morpho/Morpho.pdf
source.lm<- read.csv("C:/Users/perri/OneDrive/Images/dataset17/resultRotatedCrop.csv", header=FALSE,sep = ";")
target.lm<-read.csv("C:/Users/perri/OneDrive/Images/dataset17/resulttestbigger.csv", header=FALSE,sep = ";")
require(rgl)
myradius=3
rgl.open()
require(Rvcg)
rgl.bg(col="#cccccc")
rgl.spheres(source.lm,color="gray",radius=myradius,specular="green",texture=system.file("textures/bump_dust.png",package="rgl"),texmipmap=T, texminfilter="linear.mipmap.linear")
rgl.spheres(target.lm,color="gray",radius=myradius,specular="red",texture=system.file("textures/bump_dust.png",package="rgl"),texmipmap=T, texminfilter="linear.mipmap.linear")
#source.mesh<- delaunayn(source.lm)
#target.mesh<- delaunayn(target.lm)
#verts <- rbind(t(as.matrix(source.lm)),1)
#trgls <- as.matrix(source.mesh)
#source.mesh <- qmesh3d(verts, trgls)

#verts <- rbind(t(as.matrix(target.lm)),1)
#trgls <- as.matrix(target.mesh)
#target.mesh <- qmesh3d(verts, trgls)

for (i in 1:3) 
{
	rgl.clear()
	rgl.spheres(source.lm ,color="gray",radius=myradius,specular="green",texture=system.file("textures/bump_dust.png",package="rgl"),texmipmap=T, texminfilter="linear.mipmap.linear")
	rgl.spheres(target.lm,color="gray",radius=myradius,specular="red",texture=system.file("textures/bump_dust.png",package="rgl"),texmipmap=T, texminfilter="linear.mipmap.linear")

	icp <- icpmat(source.lm,source.lm,iterations=i,type="rigid")
	rgl.spheres(icp,color="gray",radius=myradius,specular="blue",texture=system.file("textures/bump_dust.png",package="rgl"),texmipmap=T, texminfilter="linear.mipmap.linear")
	#RMSE <- sqrt(sum(vcgKDtree(source.lm,icp[,],k=1)$distance^2)) 
RMSE=5
	readline(prompt=paste(i,RMSE,sep=" "))
     title=paste("C:/Users/perri/OneDrive/Images/dataset17/snapshot",i,sep="")
     title=paste(title,".png",sep="")

	rgl.snapshot(title)
	#par(new = TRUE)
	#plot(i,RMSE,xlim=c(0,30),ylim=c(0,200),pch=20)
	

}

