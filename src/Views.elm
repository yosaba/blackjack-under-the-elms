module Views exposing (drawButton, emptyCardLayout, footer, header, layoutCards, playPanel, newGameButton, stayButton, view)

--import Window

import Cards exposing (..)
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Html exposing (Html)
import Html.Attributes exposing ( disabled )
import Models exposing (..)
import Msgs exposing (..)


newGameButton : Model -> Element Msg
newGameButton model =
    Input.button
        [ padding 5
        , centerX
        , Border.width 1
        , Border.rounded 3
        , Border.color <| rgb255 200 200 200
        ]
        { onPress = Just NewGame
        , label = text "New Game"
        }


stayButton : Model -> Element Msg
stayButton model =
    Input.button
        [ padding 5
        , centerX
        , Border.width 1
        , Border.rounded 3
        , Border.color <| rgb255 200 200 200
        , Background.color <|
              if model.gameState == PlayerTurn ||
                 model.gameState == DealerTurn then            
                  rgb255 255 255 255
              else
                  rgb255 200 200 200
        ]
        { onPress =
              if model.gameState == PlayerTurn then
                  Just Stay
              else
                  Nothing
        , label = text "  Stay  "
        }


drawButton : Model -> Element Msg
drawButton model =
    Input.button
        [ padding 5
        , centerX
        , Border.width 1
        , Border.rounded 3
        , Border.color <| rgb255 200 200 200
        , Background.color <|
              if model.gameState == PlayerTurn ||
                 model.gameState == DealerTurn then            
                  rgb255 255 255 255
              else
                  rgb255 200 200 200
        ]
        { onPress =
              if model.gameState == PlayerTurn then
                  Just PlayerDraw
              else
                  Nothing
        , label = text "  Draw  "
        }


shouldDisableButton : Model -> Bool
shouldDisableButton model =
    model.gameState /= PlayerTurn && model.gameState /= DealerTurn

footer : Model -> Element Msg
footer model =
    el [ alignBottom,  width fill, centerX, paddingXY 0 5 ]
     <|
        row [ width fill, spacingXY 10 10 ]
            [ newGameButton model
            , stayButton model
            , drawButton model
            ]


header : Element Msg
header =
    el
        [ centerX
        , centerY
        , spacing 10
        , paddingXY 500 10
        , Font.italic
        , Font.size 36
        , Font.color <| rgb255 4 40 200
        , Font.family
            [ Font.external
                { url = "https://fonts.googleapis.com/css?family=EB+Garamond"
                , name = "EB Garamond"
                }
            , Font.sansSerif
            ]
        ]
        (text "Red River Emporium")


emptyCardLayout : Element Msg
emptyCardLayout =
    row [
     height <| px 125
     , width <| px 90
     ]
        [ none ]


getFirstCardImage : Bool -> Cards.Card -> GameState -> Element Msg
getFirstCardImage forDealer card gameState =
    let
        cardToUse =
            if forDealer &&  List.member gameState [ InitialDeal, PlayerTurn, DealerTurn ] 
            then cardBack
            else card
    in
        image [ paddingXY 10 10, height <| px 82, width <| px 60 ]
              { src = cardToUse.href, description = "Card in dealer's hand" }


layoutCards : Bool -> List Cards.Card -> GameState -> Attribute Msg -> Element Msg
layoutCards forDealer cards gameState alignment  =
    row
        [ height fill
        , width <| fillPortion 4
        , paddingXY 0 10
            , spacing 10
        , Font.color <| rgb255 255 255 255
        , alignment
        ]
    <|
        case cards of
            [] ->
                [ emptyCardLayout ]

            firstCard :: restOfCards  ->
                getFirstCardImage forDealer firstCard gameState ::
                List.map
                    (\card ->
                        image [ paddingXY 10 10, height <| px 82, width <| px 60 ]
                            { src = card.href, description = "Card in dealer's hand" }
                    )
                    restOfCards

                   
playPanel : Model -> Element Msg
playPanel model =
    row [ spacing 10, padding 20, height
        (fill
            |> maximum 300
            |> minimum 300
        ) ]
        [
          column [ spacing 10, width  <| px 100 ]
            [ none ]

         , column [
               spacing 10
               , alignTop
--               , alignLeft
               , width (fill
                     |> maximum 300
                     |> minimum 300
                 )
           ]

--         , column [ spacing 10, width  <| px 200, alignTop, alignLeft ]
            [ el [ centerX ] (text <| "Le Croupier:   " ++ String.fromInt (getHandValue model.dealerCards))
            , layoutCards True model.dealerCards model.gameState alignLeft
            ]
--        ,  column [ spacing 10, width  <| px 100 ]
--            [ none ]

        , column [ spacing 10, width <| px 400, height fill, alignTop, clipX, scrollbarX ]
            [ el [ centerX] (text "L'Histoire")
              , historyTable model
            ]
        ,  column [ spacing 10, width  <| px 10 ]
            [ none ]
        , column [ spacing 10, width <| px 200, alignTop ]
            [ text <| "Le Jouer:   " ++ String.fromInt (getHandValue model.playerCards)
            , layoutCards False model.playerCards model.gameState alignLeft
            ]
        ]

statusRow model =
    row [ spacing 10, paddingXY 20 5, centerX ]
        [ column [ spacing 10, width <| px 200 ]
            [ el [ centerX ] (text "" ) ]
        , column [ spacing 10, padding 20, width <| px 300, Font.size 24 ]
            [ el [ centerX ] ( text <| getStatusText model ) ]
        , column [ spacing 10, padding 20, width <| px 200 ]
            [ el [ centerX ] (text "" ) ]
        ]

getStatusText model =
    case model.gameState of
        Inactive    -> "Press New Game to start"
        InitialDeal -> String.append "  Player's turn    " <| String.fromChar ( Char.fromCode 0x227b ) 
        Win         -> "Victory!!"
        Lose        -> "Drown your sorrows.."
        Tie         -> "Une cravate!"
        EndGame     -> String.cons ( Char.fromCode 0x227a )  "    Dealer's Choice..."
        PlayerTurn -> String.append "  Player's turn    " <| String.fromChar ( Char.fromCode 0x227b )
        DealerTurn -> String.cons ( Char.fromCode 0x227a )  "    Waiting on the Dealer"
            

historyColumns =
    [ { header = paragraph [] [ text "Dealer Points" ]
        , width = fill
        , view =
            \historyRecord ->
                el [ alignRight ]
                   ( text <| String.fromInt  historyRecord.dealerCount )
      }
    , { header = paragraph [] [ text "Dealer Cards" ]
        , width = fill
        , view =
            \historyRecord -> text <| String.fromInt historyRecord.numDealerCards
      }
    , { header = paragraph [] [ text "Player Points" ]
        , width = fill
        , view =
            \historyRecord -> text <| String.fromInt historyRecord.playerCount
      }
    , { header = paragraph [] [ text "Player Cards" ]
        , width = fill
        , view =
            \historyRecord ->
                text <| String.fromInt historyRecord.numPlayerCards
      }
    , { header = text "Won"
        , width = fill
        , view =
            \historyRecord -> if historyRecord.win then text "1" else none
      }
    , { header = text "Lost"
        , width = fill
        , view =
            \historyRecord -> if historyRecord.lose then text "1" else none
      }
    , { header = text "Tied"
        , width = fill
        , view =
            \historyRecord -> if historyRecord.tie then text "1" else none
      }
    ]

historyTable model =
    Element.table [ centerX ]
    { data = model.history
    , columns = historyColumns
    }
    

countResults : HistoryRecord -> HistorySummaryRecord  -> HistorySummaryRecord 
countResults historyRecord historySummaryRecord =
    if historyRecord.win then
        { historySummaryRecord | wins = historySummaryRecord.wins + 1 }
    else if historyRecord.lose then
        { historySummaryRecord | loses = historySummaryRecord.loses + 1 }
    else if historyRecord.tie then
        { historySummaryRecord | ties = historySummaryRecord.ties + 1 }
    else
        historySummaryRecord
            

calculatePercentage : Int -> Int -> String
calculatePercentage value total =
    case total of
        0 -> "0%"
        _ -> ( String.fromInt <|
               round( 100.0 * ( toFloat value /   toFloat total ) ) )
             ++ "%"
    
historySummary : Model -> Element Msg
historySummary model =
    let
        numGamesPlayed = List.length model.history
        resultCounts = List.foldl countResults emptyHistorySummaryRecord model.history
    in
        row [ spacing 10, paddingXY 25 0, alignBottom ]
            [ column [ spacing 10, width  <| px 500 ]
                   [ none ]
           , column [ spacing 10, centerX, width  <| px 400 ]
                  [ row[ spacing 20 ]
                     [ el [] <| text ( "Won: "  ++  ( calculatePercentage resultCounts.wins numGamesPlayed ) )
                     , el [] <| text ( "Lost: " ++  ( calculatePercentage resultCounts.loses numGamesPlayed ) )
                     , el [] <| text ( "Tied: " ++  ( calculatePercentage resultCounts.ties numGamesPlayed ) )
                     ]      
                 ]
           ]

            
view : Model -> Html Msg
view model =
    layout
        [ Font.size 18
        , Font.bold
        , Font.color <| rgb255 4 40 200
        , Font.family
            [ Font.external
                { url = "https://fonts.googleapis.com/css?family=EB+Garamond"
                , name = "EB Garamond"
                }
            , Font.sansSerif
            ]
        -- https://commons.wikimedia.org/wiki/File:Downtown_Shreveport,_LA_and_the_Texas_Street_Bridge_(5892161678).jpg

        , Background.image "images/shreveports_hidden_treasures_opaque_67.png"
        ]
    <|
        el []
            (Element.column [ padding 20, alpha 1.0 ]
                [ header
                , playPanel model
                , historySummary model
                , statusRow model
                , footer model
                ]
            )
