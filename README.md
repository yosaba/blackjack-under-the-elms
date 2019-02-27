# Blackjack Under the Elms

Blackjack Under the Elms is a variant of the classic Vingt-et-un card game written in Elm.  The requirements for this particular game were almost completely unspecified.  If a prospective customer had released an RFP with such a paucity of definition, I would be sitting in their atrium waiting to meet with them to delineate how the system should function.

In the context in which this was developed, however, the under-specification appears to be part of the point.  Assuming, therefore, that the objective was to evoke clean code, professionalism and perhaps even some playfulness, I opted for what I hope is a healthy measure of each.

## Pattengill Rules
The first thing you will notice when you play the game is that it uses a non-standard turn-taking paradigm.  In traditional blackjack paly, once the cards are dealt, each player takes as many cards as they desire until they either bust or decide to stop, at which point the play turns to the next player and finally to the dealer.

Pattengill Rules, er, ruled, at the all too real but no longer extant Pattengill Junior High School in a far off time and place (details upon request).  Under these rules, probably accidentally developed by a group of 12 year olds who mis-interpreted their older siblings' instructions, players can decide to "stay" or to draw one card per turn and play continues through the players and dealer and back to the first player (who didn't pass the first round)  who then decides to draw or stay again.

Also, importantly, there is no betting under Pattengill Rules as the game was played after all the lunch money had already been put to good use.


## Dealer Display
Despite its Old World heritage, at Red River Emporium, the casino where Blackjack Under the Elms has becmoe wildly popular, the house rules give the dealer 2 cards in the opening deal, in line with the cards-on-the-table pragmatism of its home continent.


## Running the game
Once you have obtained the code from the repository, you can run the game by double clicking on  the pre-built	

     blackjack-under-the-elms.html

file found in the build directory.

## Setting up the environment to work on the game
To make changes to the game, you will need to install Elm

    https://guide.elm-lang.org/install.html

The game requires several Elm packages which you can install locally by opening a terminal window, navigating to the project root and typing

    source install-dependencies

## Running the game in development mode
If you have Elm installed (see above), Blackjack Under the Elms can be run in a hot-reloading fashion typical of any Elm application by opening a terminal window, navigating to the project root and typing

    elm reactor

Open a web browser and navigate to

    localhost:8000

Click on "src" and then "Main.elm".  Play should be self-explanatory from there.


## Source for the card images used in the project:
PySolFCCardsets-2.0.tar.bz2
https://sourceforge.net/projects/pysolfc/files/PySolFC-Cardsets/PySolFC-Cardsets-2.0/

## Project on GitHub:
    https://github.com/yosaba/blackjack-under-the-elms.git

