module Msgs exposing (Msg(..))

import Cards exposing ( Card )


-- Messages we use to update game state
type Msg
    = NewGame
    | ResetGame
    | PlayerDraw
    | DealerDraw
    | Stay
    | Shuffle
    | ShuffleDeck ( List Cards.Card )
    | AssessState
    | UpdateHistory
