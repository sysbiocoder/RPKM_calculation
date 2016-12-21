# sh run_rpkm.sh  Beginning_column_of_counts Ending_column_of_counts genename_column Length_column inputfolder/inputfilename outputfolder/outputfilename

rm(list = ls())
# Read feature count 
	args = commandArgs() 
	ix = grep("--args", args, fixed = TRUE)
 	if (ix < length(args))
	{
    		for (i in (ix+1):length(args))
		 {
    	 		print(paste("argument #",i-ix,"-->",args[i], sep=" "), sep = "\n")  
		}
		#Parameters passed
		begcol<-as.numeric(as.character(args[8]))
		endcol<- as.numeric(as.character(args[9]))
		genecol<- as.numeric(as.character(args[10]))
		lengthcol <- as.numeric(as.character(args[11]))
		infile <- args[12]
		outfolder <- args[13]
	} 

cat(begcol)
cat(endcol)

data <- read.table(infile,sep="\t",header=T)
rownames(data) <- data[,genecol]

RPKM <- NULL
k <- 1
head(data[,begcol])
for(i in begcol:endcol)
{
k <- k + 1
d <-data[,i]
l <- data[[lengthcol]] #Accessing the length column
cS <- sum(as.numeric(data[,i])) #Total mapped reads per sample 
RPKM[[k]] <- (10^9)*(as.numeric(data[,i]))/(as.numeric(l)*cS)

RPKM[[1]] <- data[[genecol]]
cat(k)

}

RPKM <- as.data.frame(RPKM)

colnames(RPKM) <- c("Genename",colnames(data[,begcol:endcol]))

write.table(RPKM,outfolder,quote=F,row.names=F)
