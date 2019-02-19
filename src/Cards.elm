module Cards exposing (Card, cardBack, createDeck, faceList, fillInSuit, getFaceValue, getHandValue, initialDeck, makeDeckEntry, suitList)


type alias Card =
    { suit : String
    , face : String
    , faceValue : Int
    , href : String
    }

    
cardBack : Card
cardBack =
    { suit = "", face = "", faceValue = 0, href = "./images/cardset-greywyvern/back002.png" }


--Build the deck
faceList =
    [ "01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12", "13" ]


suitList =
    [ "s", "h", "d", "c" ]


createDeck faces suits =
    case suits of
        x :: xs ->
            fillInSuit faces x ++ createDeck faces xs

        _ ->
            []


fillInSuit faces suit =
    case faces of
        x :: xs ->
            makeDeckEntry x suit :: fillInSuit xs suit

        _ ->
            []


{--
We really only need the cached face value and the image location;  the other values only make debugging marginally easier.
--}
makeDeckEntry : String -> String -> Card
makeDeckEntry face suit =
    { suit = suit
    , face = face
    , faceValue = getFaceValue face
    , href = "./images/cardset-greywyvern/" ++ face ++ suit ++ ".png"
    }


{--
  Get point value for card.
  Aces are assigned a value of -1 for later processing
--}
getFaceValue : String -> Int
getFaceValue face =
    case String.toInt face of
        Nothing ->
            0

        Just rawValue ->
            if rawValue == 1 then
                -1

            else if rawValue > 10 then
                10

            else
                rawValue


initialDeck : List Card
initialDeck =
    createDeck faceList suitList


{--
  Get point value for hand.
  We take advantage of the fact that aces are assigned a value of -1.  This allows us to easily separate the aces from the rest of the cards.  The logic follows naturally from there.
--}
getHandValue : List Card -> Int
getHandValue cards =
    let
        ( aces, others ) =
            List.partition (\card -> card.faceValue < 0) cards
        sumOthers = List.sum (List.map (\card -> card.faceValue) others)
        numAces = List.length aces
    in
        if numAces > 0 then
            if sumOthers + numAces - 1 > 10 then
                sumOthers + numAces
            else
                sumOthers + numAces + 10
        else
            sumOthers
                
