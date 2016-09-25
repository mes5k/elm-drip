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


subscriptions model =
  jsMsgs mapJsMsg



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
    | NoOp


update : Msg -> Model -> (Model, Cmd Msg )
update msg model =
    case msg of
        Increment ->
            ({ model | count = model.count + 1, num_inc = model.num_inc + 1 }
            , Cmd.none
            )

        Decrement ->
            ({ model | count = model.count - 1, num_dec = model.num_dec + 1 }
            , Cmd.none
            )

        Reset ->
            ({ model | count = 0 }
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

-- PORTS

port jsMsgs : (Int -> msg) -> Sub msg

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
