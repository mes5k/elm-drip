port module Main exposing (..)

import Html exposing (Html, button, div, text, h3)
import Html.App as Html
import Html.Events exposing (onClick)


main =
    Html.program
        { init = ( model, Cmd.none )
        , update = update
        , view = view
        , subscriptions = subscriptions
        }



-- MODEL


type alias Model =
    { count : Int, num_inc : Int, num_dec : Int }


model : Model
model =
    { count = 0, num_inc = 0, num_dec = 0 }



-- UPDATE


type Msg
    = Increment
    | Decrement
    | Reset
    | Set Int
    | NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Increment ->
            let
                newModel =
                    { model | count = model.count + 1, num_inc = model.num_inc + 1 }
            in
                ( newModel
                , Cmd.batch
                    [ increment ()
                    , storage newModel.count
                    ]
                )

        Decrement ->
            let
                newModel =
                    { model | count = model.count - 1, num_dec = model.num_dec + 1 }
            in
                ( newModel
                , storage newModel.count
                )

        Reset ->
            let
                newModel =
                    { model | count = 0 }
            in
                ( newModel
                , storage newModel.count
                )

        Set newCount ->
            ( { model | count = newCount }
            , Cmd.none
            )

        NoOp ->
            ( model
            , Cmd.none
            )



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ button [ onClick Decrement ] [ text "-" ]
        , div [] [ text (toString model.count) ]
        , button [ onClick Increment ] [ text "+" ]
        , button [ onClick Reset ] [ text "Reset" ]
        , h3 [] [ text ("Num increment: " ++ toString model.num_inc) ]
        , h3 [] [ text ("Num decrement: " ++ toString model.num_dec) ]
        ]



-- SUBSCRIPTIONS


subscriptions model =
    Sub.batch
        [ jsMsgs mapJsMsg
        , storageInput Set
        ]


port jsMsgs : (Int -> msg) -> Sub msg



-- First, we want to add the outbound port we subscribed to from the JS side.
-- This is a function that takes one argument and returns a `Cmd`.  In our case,
-- we have nothing to send so we'll make its input type the unit.


port increment : () -> Cmd msg


port storage : Int -> Cmd msg


port storageInput : (Int -> msg) -> Sub msg



-- Finally, we'll define a function that takes an `Int and produces a Msg.
-- This is the function we'll hand to our port function to take care of mapping
-- incoming data to our preferred type.


mapJsMsg : Int -> Msg
mapJsMsg int =
    case int of
        1 ->
            Increment

        2 ->
            Decrement

        _ ->
            NoOp
