-- We want to make our init, update, and view functions visible


module RandomGifPair exposing (init, update, view)

-- We know we need to pull in RandomGif

import RandomGif
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.App as Html


-- MODEL
-- our model consists of just a pair of RandomGifs.  We'll use a record with the
-- RandomGif.Model as the type of our two values.


type alias Model =
    { left : RandomGif.Model
    , right : RandomGif.Model
    }



-- We'll accept two kinds of messages - those tagged for the left component, and
-- those tagged for the right component.  This is how we route our actions
-- around.


type Msg
    = Left RandomGif.Msg
    | Right RandomGif.Msg


init : String -> String -> ( Model, Cmd Msg )
init leftTopic rightTopic =
    -- So first we'll initialize each subcomponent with the corresponding topic
    -- Remember, they return a 2-tuple of (Model, Cmd Msg) just like this
    -- function does.
    let
        ( left, leftCmd ) =
            RandomGif.init leftTopic

        ( right, rightCmd ) =
            RandomGif.init rightTopic
    in
        -- We'll return our model, which is just a record with a left and a right
        -- key, and a list of messages
        ( { left = left
          , right = right
          }
          -- For our cmds, we'll do two things.  First off, we want to batch a list
          -- of cmds so that they all get lumped together and spawned independently
          -- but simultaneously.
        , Cmd.batch
            -- Then we want to map them so that we can route the messages to the
            -- appropriate component.  Cmd.map is useful for transforming the return
            -- type of a Cmd - in this case, tagging it with the component so we
            -- know which component to route it to.
            [ Cmd.map Left leftCmd
            , Cmd.map Right rightCmd
            ]
        )



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    -- We'll switch on which component we're interacting with
    case msg of
        -- If it's the left one
        Left leftMsg ->
            let
                -- We'll call RandomGif.update on the left model, with the wrapped
                -- message with the `Left` tag removed
                ( left, cmd ) =
                    RandomGif.update leftMsg model.left
            in
                -- And we'll update the left component
                ( { model | left = left }
                  -- And we'll return whatever cmds would have come out of the left
                  -- model's update action, mapped to `Left`.  This way when they return
                  -- they will also be routed to the appropriate component.
                , Cmd.map Left cmd
                )

        -- The exact same situation applies for the right.
        Right rightMsg ->
            let
                ( right, cmd ) =
                    RandomGif.update rightMsg model.right
            in
                ( { model | right = right }
                , Cmd.map Right cmd
                )



-- VIEW


view : Model -> Html Msg
view model =
    -- We'll just wrap each of the RandomGif.view functions inside a div together
    div [ style [ ( "display", "flex" ) ] ]
        -- The way to wire these two components together is to map the messages they
        -- output to a tagged version that we can handle appropriately.
        -- Here, we'll tag them with Left and Right.
        [ Html.map Left (RandomGif.view model.left)
        , Html.map Right (RandomGif.view model.right)
        ]
