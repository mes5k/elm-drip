-- We'll name our module, and expose our init, update, and view functions


module RandomGif exposing (init, update, view, Model, Msg)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Task
import Http
import Json.Decode as Json


-- We'll define the model.  Our RandomGif component just takes a topic and the
-- url for the gif we're displaying.


type alias Model =
    { topic : String
    , gifUrl : String
    }



-- We'll define an `init` function to create our initial data - we're
-- introducing a new concept here


init : String -> ( Model, Cmd Msg )
init topic =
    ( Model topic "assets/cat.gif"
    , getRandomGif topic
    )



-- UPDATE
-- Our messages will be either to `RequestMore`, which asks for a new gif,
-- `FetchSucceed String`, which is what a successful http request will produce,
-- and `FetchFail`, which is what we'll produce if the http request fails.


type Msg
    = RequestMore
    | FetchSucceed String
    | FetchFail


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        -- When we request another gif, we won't update the model but we'll add a new
        -- Cmd that we want to take place - another call to `getRandomGif`
        RequestMore ->
            ( model, getRandomGif model.topic )

        -- When the Cmd has completed its HTTP request, it will inject a new Msg
        -- with the new gif url in the case of success.  We'll take that url and update
        -- our model.
        -- We don't want to introduce new Cmds with this update, so we explicitly add a
        -- Cmd.none command to our returned 2-tuple.
        FetchSucceed maybeUrl ->
            ( Model model.topic maybeUrl
            , Cmd.none
            )

        -- If the request failed, we get a `FetchFail` message...we won't do anything with
        -- it, but you could use this to display an error message to the user.
        FetchFail ->
            ( model, Cmd.none )



-- VIEW
-- Infix function used to "cleany" express tuples


(=>) =
    (,)


view : Model -> Html Msg
view model =
    -- We want a div with an h2, a gif, and a button to request more gifs
    div [ style [ "width" => "200px" ] ]
        -- we'll extract the styles into their own functions
        [ h2 [ headerStyle ] [ text model.topic ]
          -- We'll just show the model's gifUrl using css to make it the background of a
          -- div
        , div [ imgStyle model.gifUrl ] []
          -- And we'll add a button to RequestMore
        , button [ onClick RequestMore ] [ text "More Please!" ]
        ]


headerStyle : Attribute Msg
headerStyle =
    style
        [ "width" => "200px"
        , "text-align" => "center"
        ]


imgStyle : String -> Attribute Msg
imgStyle url =
    style
        [ "display" => "inline-block"
        , "width" => "200px"
        , "height" => "200px"
        , "background-position" => "center center"
        , "background-size" => "cover"
        , "background-image" => ("url('" ++ url ++ "')")
        ]



-- CMDS
-- getRandomGif takes a string - the topic for our gif - and returns a Cmd
-- that results in an message


getRandomGif : String -> Cmd Msg
getRandomGif topic =
    let
        url =
            randomUrl topic
    in
        -- we'll get a URL - which we construct via the `randomUrl` function with our
        -- topic - and decode it, extracting the data we want out of it.  We'll use `Task.perform`
        -- to request our task to be performed.
        --    - if it fails, we'll return `FetchFail`
        --    - if it succeeds, it will return `FetchSucceed` with the result of `decodeGifUrl`
        --    -- each of the first two arguments are functions that are called with
        -- the result of the decodeGifUrl Json.Decoder
        Task.perform (\_ -> FetchFail) FetchSucceed (Http.get decodeGifUrl url)



-- We used the `randomUrl` function before - here we'll define it.  It takes a
-- topic and returns an Http url that includes our api key and tag as parameters
-- in the url for a random gif from giphy.


randomUrl : String -> String
randomUrl topic =
    Http.url "http://api.giphy.com/v1/gifs/random"
        [ "api_key" => "dc6zaTOxFJmzC"
        , "tag" => topic
        ]



-- Now we get to the `decodeGifUrl` function.  This returns a Json.Decoder for a
-- String.  We use a few functions from the `Json` module, which let us dig into
-- a Json value and extract a string from the value.  This results in a decoder
-- that, when provided with a string representing an object with a `data` key
-- which contains an object with an `image_url` key, will return the value in
-- the `image_url` key as a String type.


decodeGifUrl : Json.Decoder String
decodeGifUrl =
    Json.at [ "data", "image_url" ] Json.string
