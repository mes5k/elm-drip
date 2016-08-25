import Html exposing (Html, button, div, text, h3)
import Html.App as Html
import Html.Events exposing (onClick)


main =
  Html.beginnerProgram { model = model, view = view, update = update }


-- MODEL

type alias Model = { count: Int, num_inc: Int, num_dec: Int }


model : Model
model = { count = 0, num_inc = 0, num_dec = 0 }


-- UPDATE

type Msg = Increment | Decrement | Reset

update : Msg -> Model -> Model
update msg model =
  case msg of
    Increment -> { model | count = model.count + 1, num_inc = model.num_inc + 1 }
    Decrement -> { model | count = model.count - 1, num_dec = model.num_dec + 1 }
    Reset -> { model | count = 0 }


-- VIEW

view : Model -> Html Msg
view model =
  div []
    [ button [ onClick Decrement ] [ text "-" ]
    , div [] [ text (toString model.count) ]
    , button [ onClick Increment ] [ text "+" ]
    , button [ onClick Reset ] [ text "Reset" ]
    , h3 [] [ text ("Num increment: " ++ toString model.num_inc)]
    , h3 [] [ text ("Num decrement: " ++ toString model.num_dec)]
    ]
