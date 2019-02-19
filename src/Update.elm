module Update exposing (newGame, playerDraw, update)

import Cards exposing (initialDeck)
import Delay exposing (..)
import Models exposing (..)
import Msgs exposing (..)

-- package: elm-community/random-extra
import Random exposing (Seed, generate)
import Random.List exposing (shuffle)


-- The message dispatcher for modulating game state
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NewGame ->
            ( newGame model ) |> assessState

        ResetGame ->
            ( Models.initialModel, Cmd.none )

        PlayerDraw ->
            ( playerDraw model ) |> assessState

        DealerDraw ->
            ( dealerDraw model ) |> assessState

        Stay ->
            ( { model | gameState = EndGame } ) |> assessState

        Shuffle ->
          ( model, generate ShuffleDeck (shuffle model.deck) )
              
        ShuffleDeck shuffledList ->
          ( { model | deck = shuffledList }, Cmd.none )

        AssessState ->
             assessState model
                  
        UpdateHistory ->
            updateHistory model


-- When we start a new game, we need to remove cards from the player's and dealer's hands.  we deal new cards so we change the game state accordingly
updateModelForNewGame : Model -> Model
updateModelForNewGame model =
     { model
         |
          dealerCards = []
         , playerCards = []
         , gameState = InitialDeal
     }


-- Deal the first 2 cards to each player
newGame : Model -> Model
newGame model =
    playerDraw ( updateModelForNewGame model )
    |> dealerDraw
    |> playerDraw
    |> dealerDraw


-- Draw a cards.  If the deck is exhausted, get a new one.
drawCard : Model -> ( Cards.Card, List Cards.Card )
drawCard model =
    case model.deck of
        x :: xs ->
            ( x, xs )

        [] ->
            -- reset the deck
            let
                newCard =
                    case List.head initialDeck of
                        Just card ->
                            card

                        Nothing ->
                            Cards.cardBack

                newDeck =
                    case List.tail initialDeck of
                        Just cards ->
                            cards

                        Nothing ->
                            initialDeck
            in
            ( newCard, newDeck )


mustDealerDraw : Model -> Bool
mustDealerDraw model =
    Cards.getHandValue model.dealerCards < 17


dealerDraw : Model -> Model
dealerDraw model =
    if mustDealerDraw model then
        let
            ( newCard, newDeck ) =
                drawCard model
        in
        { model
            | dealerCards = newCard :: model.dealerCards
            , deck = newDeck
        }
    else
        model


playerDraw : Model -> Model
playerDraw model =
    let
        ( newCard, newDeck ) =
            drawCard model
    in
    { model
        | playerCards = newCard :: model.playerCards
        , deck = newDeck
    }


assessGame : Model -> GameState
assessGame model =
    let
        playerHandValue =
            Cards.getHandValue model.playerCards
        dealerHandValue =
            Cards.getHandValue model.dealerCards
    in
    if model.gameState == PlayerTurn then
        -- Player just had a turn
        if playerHandValue > maxHandValue then
            Lose

        else if dealerHandValue >= minDealerValue &&
            playerHandValue > dealerHandValue then
                 -- Dealer can not play so player wins
                 Win
        else
            DealerTurn

    -- We are in an End Game or Dealer just had a turn 
    -- Either way:
    else if dealerHandValue > maxHandValue then
            Win

    else if model.gameState == EndGame then
        if dealerHandValue < minDealerValue then
            -- Dealer has to keep drawing
            EndGame
        else if dealerHandValue > maxHandValue then
            Win
        else if dealerHandValue > playerHandValue then
            Lose
        else if dealerHandValue == playerHandValue then
            Tie
        else
            -- Dealer can no longer draw and has fewer points than player
            Win

    else if dealerHandValue >= minDealerValue then
        if dealerHandValue < playerHandValue then
            Win
        else if playerHandValue == 21 then
             if dealerHandValue == 21 then
                 Tie
             else
                 -- Dealer can't draw
                 Win
        else
             -- The player has less than 21 so let her decide
             PlayerTurn
    else if model.gameState == InitialDeal && playerHandValue == 21 then
        -- The cards have just been dealt, the player has a blackjack and
        -- the dealer does not (and in fact has less than 17 points;
        -- the other case is accounted for above)
        Win
    else
        PlayerTurn

     
-- Modulate the game state based on previous state and cards held after the last play
assessState : Model -> ( Model, Cmd Msg )
assessState model =
    case assessGame model of
        InitialDeal ->
            ( { model | gameState = PlayerTurn }, Cmd.none )
            
        Win ->
            ( { model | gameState = Win } ) |> updateHistory

        Lose ->
            ( { model | gameState = Lose } ) |> updateHistory

        Tie ->
            ( { model | gameState = Tie } ) |> updateHistory

        PlayerTurn ->
            ( { model | gameState = PlayerTurn }, Cmd.none )

        DealerTurn ->
            ( { model | gameState = DealerTurn },  Delay.after 1000 Millisecond DealerDraw  )

        EndGame ->
            ( { model | gameState = EndGame },  Delay.after 1000 Millisecond DealerDraw  )
    
        Inactive ->
            ( { model | gameState = Inactive }, Cmd.none )


-- Add a new record to the stored history based on the just finished game
updateHistory : Model -> ( Model, Cmd Msg )
updateHistory model =
    let
        newHistoryRecord =
            {
            dealerCount = Cards.getHandValue model.dealerCards
            , numDealerCards = List.length model.dealerCards
            , playerCount = Cards.getHandValue model.playerCards
            , numPlayerCards = List.length model.playerCards
            , win = model.gameState == Win
            , lose = model.gameState == Lose
            , tie = model.gameState == Tie
            }
    in
        ( { model | history = model.history ++ [ newHistoryRecord ] }, Cmd.none )





