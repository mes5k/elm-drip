module Main exposing (..)

import Html.App as Html

-- import RandomGifPair instead of RandomGif
import RandomGifPair exposing (init, update, view)

main =
  Html.program
    { init = init "funny cats" "funny dogs"
    , update = update
    , view = view
    , subscriptions = subscriptions
    }


subscriptions model =
  Sub.none
