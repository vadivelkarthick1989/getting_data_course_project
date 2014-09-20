
#loading train data 
traindata<-read.table("./UCI HAR Dataset/train/X_train.txt",sep="",header=FALSE)
features<-read.table("./UCI HAR Dataset/features.txt",sep="",header=FALSE)
#subsetting traing data
traindata_subset<-traindata[,c(features[grepl("mean",features$V2)|grepl("std",features$V2),]$V1)]
#assigning names to train data columns
names(traindata_subset)<-features[grepl("mean",features$V2)|grepl("std",features$V2),]$V2
traindata_y<-read.table("./UCI HAR Dataset/train/y_train.txt",sep="",header=FALSE,col.names = "labels")
train_subject<-read.table("./UCI HAR Dataset/train/subject_train.txt",sep="",header=FALSE,col.names = "subject")
train_data_combined<-cbind(traindata_subset,traindata_y,train_subject)
#loading labels 
activity_labels<-read.table("./UCI HAR Dataset/activity_labels.txt",sep="",header=FALSE,col.names = c("id","activity"))
#joining train data with labels
train_data_final<-merge(train_data_combined,activity_labels,by.x="labels",by.y="id",all=FALSE)

#loading test data
testdata<-read.table("./UCI HAR Dataset/test/X_test.txt",sep="",header=FALSE)
#subsetting test data
testdata_subset<-testdata[,c(features[grepl("mean",features$V2)|grepl("std",features$V2),]$V1)]
#assigning names to test data columns
names(testdata_subset)<-features[grepl("mean",features$V2)|grepl("std",features$V2),]$V2
testdata_y<-read.table("./UCI HAR Dataset/test/y_test.txt",sep="",header=FALSE,col.names = "labels")
test_subject<-read.table("./UCI HAR Dataset/test/subject_test.txt",sep="",header=FALSE,col.names = "subject")
test_data_combined<-cbind(testdata_subset,testdata_y,test_subject)
#joining test data with labels
test_data_final<-merge(test_data_combined,activity_labels,by.x="labels",by.y="id",all=FALSE)
#combining train & test data
final_data<-rbind(train_data_final,test_data_final)

library(reshape)
#grouping final_data by subject & activity
grpdata<-melt(final_data, id=c("subject","activity"))
tidy<-grpdata[grpdata$variable!="labels",]
#applying avg on all coulumns
tidy_avg<- cast(tidy, subject+activity~variable, mean)
#dumping data into file 
write.table(tidy_avg,file="./tidydata_output.txt",row.names=FALSE)