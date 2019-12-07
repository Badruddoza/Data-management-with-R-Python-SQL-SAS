rm(list=ls())

p<-.5;num_row<-10;num_col<-10
matrix<-matrix(c(0),num_row,num_col)
for(j in 1:num_col){
for(i in 1:num_row){
 matrix[i,j]<-rbinom(1,1,p) 
}
}
matrix

sum<-matrix(c(0),num_row,1)
for(i in 1:num_row){
  sum[i]<-sum(matrix[i,])
}
res<-cbind.data.frame(zeros=num_col-sum,serial=rep(1:num_col))
ii<-res[which(res[,1]==max(res[,1])),2]
print("Row(s) with maximum zeros:")
paste(ii);

# The same thing can be done by one line code
rm(list=ls())
n_row=4;n_col=5
which.max(-rowSums( matrix(c((rbinom(n_row*n_col,1,.5))),n_row,n_col) ))
