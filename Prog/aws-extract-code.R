
library(sparklyr)
library(dplyr)
library(aws.s3)

config <- spark_config()
sc <- spark_connect(master = "yarn-client", config = config, version = '2.2.0')

assessment <- spark_read_parquet(sc, "assessment", "s3n://ui-blackknight/parquet-data/BKFS_20181105/Assessment.parquet", memory = FALSE)

dccog <- as.character(c(11001, 24031, 24021, 24033, 24017, 51013, 51153,
                        51610, 51600, 51683, 51685, 51510, 51107, 51059))

assess <- assessment %>% filter(fipscodestatecounty %in% dccog)

assess1 <- assess %>% 
  select(-currentownername,
         -legalbriefdescription,
         -legalbriefdescriptionfull,
         -owner2lastname,
         -legallotcode,
         -rawmailingfullstreetaddress,
         -rawpropertyfullstreetaddress,
         -rawpropertystreetname,
         -`2ndassesseeownernameordba`)

# set AWS secret keys

write_out <- function(dataset, namein,direct_download){
  bucket <- "ui-blackknight"
  bucket_path <- "extracts/"
  pathin <- paste("s3n://",bucket,"/",bucket_path,namein, sep="")
  pathin2 <- paste("s3://",bucket,"/",bucket_path,namein, sep="")
  spark_write_csv(dataset,pathin,header = FALSE,mode="overwrite")
  tempdf <- data.frame(matrix(vector(), 0, length(colnames(dataset)), dimnames=list(c(), colnames(dataset))), stringsAsFactors=F)
  write.csv(tempdf, 'temp.csv', row.names = FALSE)
  put_object('temp.csv', bucket = bucket, object = paste(bucket_path,namein,"/","0_header.csv", sep=""))
  Sys.setenv(inputpath=paste(pathin,"/",sep=""))
  Sys.setenv(inputpath2=pathin2)
  Sys.setenv(outputpath=paste(pathin,".csv",sep=""))
  Sys.setenv(localpath=paste(pathin2,".csv",sep=""))
  print("Merging multiple files. DO NOT BE ALARMED.")
  system('hadoop fs -text ${inputpath}* | hadoop fs -put - ${outputpath}', ignore.stderr = TRUE, ignore.stdout = TRUE)
  if (direct_download == FALSE){
    system('aws s3 cp ${localpath} .')
    system('aws s3 rm ${localpath}')
  }
  system('aws s3 rm ${inputpath2} --recursive')
  print("The file is ready to be downloaded from the file browser on the bottom right of your screen. Check the box next to the file, click 'More' and then click 'Export' to download the extract to your confidential folder on SAS1.")
}

write_out(assess1, "dc-cog-assessment_20181228", direct_download = FALSE)
