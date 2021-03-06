module Main exposing (main)

--import Html exposing (Html, text, pre)

import Browser
import Cards exposing (..)
import Models exposing (..)
import Msgs exposing (..)
import Update exposing (..)
import Views exposing (..)


type Card
    = String

init : () -> ( Model, Cmd Msg )
init _ =
    update Shuffle ( initialModel ) 


subscriptions model =
    Sub.none


main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }
