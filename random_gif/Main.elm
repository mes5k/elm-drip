module Main exposing (..)

import RandomGif exposing (init, update, view)
import Html.App as Html


-- Now we'll define our app, which will use `program`.  For the most
-- part, you can treat this as `beginnerProgram`, but it takes an `init`
-- function instead of the model, and also provides a place to provide
-- subscriptions.


main =
    Html.program
        -- We'll initialize it to find gifs about cats that are funny.
        { init =
            init "funny cats"
            -- Then we'll pass the update and view functions from RandomGif
        , update = update
        , view =
            view
            -- Finally, we'll pass a subscriptions function
        , subscriptions = subscriptions
        }



-- We have no subscriptions, so we'll just return Sub.none.
-- Note: this function is passed the model, but we'll just ignore it for now.
-- We'll talk more about subscriptions later.


subscriptions model =
    Sub.none
