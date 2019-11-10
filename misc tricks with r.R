



# create an indentity matrix from scratch
rm(list=ls())
mat=matrix(rep(0),nrow=4,ncol=4)
nrow=dim(mat)[1]
ncol=dim(mat)[2]
for(i in 1:nrow){
  for(j in 1:ncol){
    if(i==j){
      mat[i,j]=1
    }
  }
}
View(mat)

# multiply each element of a matrix
rm(list = ls())
mat=matrix(c(1:16),nrow=4,ncol=4)
nrow=dim(mat)[1]
ncol=dim(mat)[2]
solution=1
for(i in 1:nrow){
  for(j in 1:ncol){
    el=mat[i,j]
    solution=solution*el
    print(solution)
  }
}
solution
