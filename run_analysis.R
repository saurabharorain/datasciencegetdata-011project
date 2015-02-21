
library(plyr)
library(dplyr)

if(!file.exists("data.zip")){
  url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  #We are running this on ubuntu so we need the method = "curl" set to download.
  download.file(url,"data.zip",method="curl")
  unzip("data.zip")
}

readData <- function(type,features,requiredfeatures){
  
  subjectfile <- paste("UCI HAR Dataset/",type,"/subject_",type,".txt",sep="")

  subject <- read.csv(subjectfile,sep = " ",header = FALSE,col.names=c("subject"))
  
  xfile <- paste("UCI HAR Dataset/",type,"/X_",type,".txt",sep="")
  
  X <- read.csv(xfile,header = FALSE,na.strings="NA",encoding="UTF-8",sep="")
  
  colnames(X) <- features$V2
  
  Xr <- X[,features$V2 %in% requiredFeatures$V2]
  
  d1 <- merge(subject,Xr,by="row.names",all=TRUE);
  colnames(d1)[1] <- "id"
  d1$id <- as.numeric(d1$id)
  d1 <- arrange(d1,id)
  
  yfile <- paste("UCI HAR Dataset/",type,"/y_",type,".txt",sep="")
  
  Y <- read.csv(yfile,sep = " ",header = FALSE)
  colnames(Y) <- c("activity_label")
  
  
  d2 <- merge(d1,Y,by.x="id",by.y="row.names",all=TRUE);
  
  d2
}

#----------------Reading common datasets and required Features extraction------

#load features
features <- read.csv("UCI HAR Dataset/features.txt",sep = " ",header = FALSE);

#extract features which are mean and standard deviation

requiredFeatures <- features[grepl("mean[(]{1}[)]{1}",features$V2) | grepl("std[(]{1}[)]{1}",features$V2),]

#load activity labels

activitylabel <- read.csv("UCI HAR Dataset/activity_labels.txt",sep = " ",header = FALSE);


train <- readData("train",features,requiredFeatures);

test <- readData("test",features,requiredFeatures);

#merge the rows.
merged <- rbind(train,test)

#merged remove the id column
merged <- select(merged,-id)

#aggregate on subject and activity_label
tmp <- aggregate(.~ (subject + activity_label) ,merged,FUN=mean,na.rm=TRUE)

#add the activity label
tmp$activity<- activitylabel[tmp$activity_label,]$V2

tmp = select(tmp,-activity_label)
#tidy dataset
tidy <- cbind(select(tmp,subject,activity),select(tmp,-subject,-activity))

write.table(tidy,"tidy.txt",row.names=FALSE)
