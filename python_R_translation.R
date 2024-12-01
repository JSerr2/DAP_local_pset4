mylist <- c(
  "apple", "brave", "crane", "drive", "eagle",
  "fable", "grape", "house", "input", "joker",
  "knife", "lemon", "mango", "nerve", "ocean"
)

myfunction1 <- function(mylist, mynumber2) {
  mystring1 <- sample(mylist, 1)
  mynumber1 <- 0
  
  cat("Welcome!\n")
  cat(sprintf("You have %d attempts.\n", mynumber2))
  
  while (mynumber1 < mynumber2) {
    cat("Enter your guess: ")
    mystring2 <- tolower(trimws(readline()))
    
    if (nchar(mystring2) != 5 || !grepl("^[a-zA-Z]+$", mystring2)) {
      cat("Invalid input.\n")
      next
    }
    
    mynumber1 <- mynumber1 + 1
    
    if (mystring2 == mystring1) {
      cat(sprintf("Congratulations! You won in %d attempts.\n", mynumber1))
      break
    } else {
      mymessage <- ""
      for (i in 1:5) {
        if (substr(mystring2, i, i) == substr(mystring1, i, i)) {
          mymessage <- paste0(mymessage, substr(mystring1, i, i))
        } else {
          mymessage <- paste0(mymessage, "_")
        }
      }
      
      mynumber3 <- mynumber2 - mynumber1
      cat(sprintf("Wrong! Here's what you got right: %s\n", mymessage))
      cat(sprintf("You have %d attempts left.\n", mynumber3))
    }
  }
  
  if (mynumber1 == mynumber2) {
    cat(sprintf("Sorry, you lost. The correct answer was: '%s'.\n", mystring1))
  }
}


myfunction1(mylist, 5)
