module Models exposing (GameState(..), Model, HistorySummaryRecord, HistoryRecord, maxHandValue, minDealerValue, initialModel, emptyHistorySummaryRecord ) 

import Cards exposing (..)


type alias Model =
    { playerCards : List Cards.Card
    , dealerCards : List Cards.Card
    , deck : List Cards.Card
    , gameState : GameState
    , history : List HistoryRecord
    }

    
-- Data we store for statistical purposes
type alias HistoryRecord =
    { dealerCount : Int
    , numDealerCards : Int
    , playerCount : Int
    , numPlayerCards : Int
    , win : Bool
    , lose : Bool
    , tie : Bool
    }


--Maintain running total of wins, loses and ties    
type alias HistorySummaryRecord =
    { wins : Int
    , loses : Int
    , ties : Int
    }

-- Starting value (aggregator) for computing history summary
emptyHistorySummaryRecord : HistorySummaryRecord
emptyHistorySummaryRecord =
    {
        wins = 0
        , loses = 0
        , ties = 0
    }


-- Set of disjoint game states we need to track, each with specific behavior
type GameState
    = Inactive
    | InitialDeal
    | Win
    | Lose
    | Tie
    | PlayerTurn
    | DealerTurn
    | EndGame  -- Player has "passed" so final actions are up to the dealer



maxHandValue =
    21


minDealerValue =
    17

        

initialModel : Model
initialModel  =
    {  playerCards = [ ]
    , dealerCards = [ ]
    , deck = initialDeck
    , gameState = Inactive
    , history = []             
    }
