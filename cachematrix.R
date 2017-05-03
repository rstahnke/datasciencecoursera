##  These functions invert and store the result of matrix inversion

## Here a special cached matrix is created
makeCacheMatrix <- function(x = matrix()) {
	m <- NULL
	set <- function(y) {
		x <<- y
		m <<- NULL
	}
	get <- function() x
	setinverse <- function(inverse) m <<- inverse
	getinverse <- function() m
	list(set = set, get = get, setinverse = setinverse, getinverse=getinverse)
}

## This function calculates the matrix inverse if it
## if it is not already cached in m

cacheSolve <- function(x, ...) {
	m <- x$getinverse()
	if (!is.null(m)) {
		return(m)
	}
	data <- x$get
	m <- solve(data)
	x$setinverse(m)
	m
## Return a matrix that is the inverse of 'x'
}
