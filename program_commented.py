import random

# creates a list of five letter words

retmylist = [
    "apple", "brave", "crane", "drive", "eagle",
    "fable", "grape", "house", "input", "joker",
    "knife", "lemon", "mango", "nerve", "ocean"
]

print (retmylist)

# Creates a function which takes two inputs, a random word from the list and the maximum number of words allowed for the player to guess the correct word.
def myfunction1(mylist, mynumber2):
    mystring1 = random.choice(mylist).lower()
    mynumber1 = 0

# This prints a welcome announcements and tells you how many attempts you have to guess the words

    print("Welcome!")
    print("You have {mynumber2} attempts.")
    
# Starts a loop where the player will guess the word    
    while mynumber1 < mynumber2:
# the player will put input their guess here
        mystring2 = input("Enter your guess: ").lower().strip()
# this will check if the word is a five letter word or not and print invalid input if its not        
        if len(mystring2) != 5 or not mystring2.isalpha():
            print("Invalid input.")
            continue
# Increases how many attempts the player has        
        mynumber1 = mynumber1 + 1
# This part checks if the player guessed the correct word        
        if mystring2 == mystring1:
            print(f"Congratulations! You won in {mynumber1} attempts.")
            break # ends the loop if the player guesses correctly
        else:
          
          # this part of the code generates a hint by comparing the guessed word and the selected word
            mymessage = ''
            for i in range(5):
                if mystring2[i] == mystring1[i]:
                    mymessage = mymessage + mystring1[i]
                else:
                    mymessage = mymessage + '_'
        # Here, the code calculates the number of remaining attempts
                    
            mynumber3 = mynumber2 - mynumber1
            print(f"Wrong! Here's what you got right: {mymessage}")  
            print(f"You have {mynumber3} attempts left.")
    
    # Whe player runs out of attempts, the correct word is revealed
    
    if mynumber1 == mynumber2:
        print(f"Sorry, you lost. The correct answer was: '{mystring1}'.")
# Calls the function and uses 5 attempts
myfunction1(mylist, 5)

