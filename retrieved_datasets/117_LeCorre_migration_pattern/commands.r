###### identify clusters
library(NbClust)
tab<-read.table("WRcentro.txt",sep="\t",h=T)
rfh<-subset(tab,tab$herd==2)
rgh<-subset(tab,tab$herd==1)
ncrfh<-NbClust(rfh[,6:7],method="average",index="all")                          #index="all" all indices except "gap","gamma", "gplus" and "tau" are tested. "gamma", "gplus" and "tau" indices were tested separetly as "gap" index estimation failed
ncrgh<-NbClust(rgh[,6:7],method="average",index="alllong")                      #index="alllong" all indices are tested.
rfh<-cbind(rfh,ncrfh[4])
rgh<-cbind(rgh,ncrgh[4])
gp<-rbind(rfh,rgh)
write.table(gp,"WRcentro.txt",sep="\t",col.names=T,row.names=F,quote=F)



###### random forest
library(extendedForest)                                                         #access link (last access 20 May 2019): https://r-forge.r-project.org/R/?group_id=973
tab<-read.table("db_rf.txt",sep="\t",h=T)
pop_rfh<-read.table("estipop_rfh.txt",sep="\t",h=T)
pop_rgh<-read.table("estipop_rgh.txt",sep="\t",h=T)

listRF<-list()
listimp<-list()
tabimp<-as.data.frame(matrix(data=0,nrow=12000,ncol=5)) #rfh: ncol=5, rgh: ncol=6
taberr<-as.data.frame(matrix(data=0,nrow=1000,ncol=4)) #rfh: ncol=4, rgh: ncol=5

for (i in 1:1000)
{
  print(i)
  for (j in 1:length(unique(tab$year)))
    {
    ye<-unique(tab$year)[j]
    prfh<-pop_rfh[pop_rfh[,1]==(ye-1),i+1]
    prgh<-pop_rgh[pop_rgh[,1]==(ye-1),i+1]

    tab$popRFH[tab$year==ye]<-prfh
    tab$popRGH[tab$year==ye]<-prgh
    }

  rfh<-tab[tab$herd==2,-c(1:4)]
  rfh$cluster<-droplevels(rfh$cluster)
  rgh<-tab[tab$herd==1,-c(1:4)]
  rgh$cluster<-droplevels(rgh$cluster)

  mincl<-min(table(rfh$cluster))                                                                          # change herd rfh/rgh
  listimp[[i]]<-rfImpute(cluster~.,rfh,ntree=3000,mtry=4,maxLevel=6,corr.threshold=0.5,corr.method="kendall",sampsize=rep(mincl,length(levels(rfh$cluster)))) # change rfh/rgh
  imp<-listimp[[i]]
  rftree<-randomForest(cluster~.,imp,ntree=3000,mtry=4,maxLevel=6,corr.threshold=0.5,corr.method="kendall",sampsize=rep(mincl,length(levels(imp$cluster))),importance=TRUE)
  listRF[[i]]<-rftree
  taberr[i,]<-rftree$err.rate[3000,]
  tabimp[(1+12*(i-1)):(12+12*(i-1)),1]<-rownames(rftree$importance)
  tabimp[(1+12*(i-1)):(12+12*(i-1)),2:ncol(tabimp)]<-rftree$importance[,1:(ncol(rftree$importance)-1)]
}

tabimp[,1]<-as.factor(tabimp[,1])
colnames(tabimp)<-c("variable",levels(imp$cluster),"all")
colnames(taberr)<-c("global",levels(imp$cluster))
save(listRF,file="listRF_rfh")                                                  # change herd rfh/rgh
save(listimp,file="listimp_rfh")                                                # change herd rfh/rgh
write.table(tabimp,"tabimp_rfh.txt",sep="\t",col.names=T,row.names=F,quote=F)   # change herd rfh/rgh
write.table(taberr,"taberr_rfh.txt",sep="\t",col.names=T,row.names=F,quote=F)   # change herd rfh/rgh



####### partial dependence
####### extract x/y coordinates of partial dependance for each class from each RF, used to build figure 4 and 5. /!\ very long to run
library(extendedForest)                                                         #access link (last access 20 May 2019): https://r-forge.r-project.org/R/?group_id=973
load("listRF_rgh")                                                              #change herd rfh/rgh
load("listimp_rgh")                                                             #change herd rfh/rgh

clust<-unique(listimp[[1]]$cluster)
vars<-colnames(listimp[[1]])

for (j in 2:13)
  {
  for (k in 1:length(clust))
    {
    lvl<-clust[k]
    a<-as.data.frame(matrix(data=0,ncol=0,nrow=50))
    b<-as.data.frame(matrix(data=0,ncol=0,nrow=50))
    for (i in 1:1000)
      {
      print(paste(vars[j],lvl,i,sep=" - "))
      rftree<-listRF[[i]]
      tab<-listimp[[i]]
      pp<-partialPlot(rftree,tab,x.var=as.character(vars[j]),lvl,n.pt=50,rug=T,plot=F)
      b<-cbind(b,pp$x)
      a<-cbind(a,pp$y)
      }
    write.table(a,paste("rgh_",lvl,"_",vars[j],"_y.txt",sep=""),sep="\t",col.names=T,row.names=F,quote=F)             #change herd rfh/rgh
    write.table(b,paste("rgh_",lvl,"_",vars[j],"_x.txt",sep=""),sep="\t",col.names=T,row.names=F,quote=F)             #change herd rfh/rgh
      }
   }

