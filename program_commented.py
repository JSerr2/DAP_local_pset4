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
    
    while mynumber1 < mynumber2:
        mystring2 = input("Enter your guess: ").lower().strip()
        
        if len(mystring2) != 5 or not mystring2.isalpha():
            print("Invalid input.")
            continue
        
        mynumber1 = mynumber1 + 1
        
        if mystring2 == mystring1:
            print(f"Congratulations! You won in {mynumber1} attempts.")
            break
        else:
            mymessage = ''
            for i in range(5):
                if mystring2[i] == mystring1[i]:
                    mymessage = mymessage + mystring1[i]
                else:
                    mymessage = mymessage + '_'
            mynumber3 = mynumber2 - mynumber1
            print(f"Wrong! Here's what you got right: {mymessage}")  
            print(f"You have {mynumber3} attempts left.")
    
    if mynumber1 == mynumber2:
        print(f"Sorry, you lost. The correct answer was: '{mystring1}'.")

myfunction1(mylist, 5)

