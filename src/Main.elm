port module Main exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


-- PORTS

{-| Request to compile markdown string into HTML markup with
    external compiler.

    Outbound.
-}
port compileMarkdown : String -> Cmd msg

{-| Receive compiled HTML text from JavaScript.

    Incoming.
-}
port htmlSource : (String -> msg) -> Sub msg


{- main -}
main : Program () Model Msg
main =
  Browser.element
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }


-- MODEL

type alias Model =
  { showSource : Bool
  , htmlText : String
  }

init : () -> ( Model, Cmd Msg )
init _ =
  ( { showSource = False, htmlText = "" }
  , Cmd.none
  )


-- UPDATE

type Msg
  = Markdown String
  | CompiledHtml String

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    Markdown mdText ->
      ( model, compileMarkdown mdText )

    CompiledHtml result ->
      ( { model | htmlText = result }
      , Cmd.none
      )


-- VIEW

view : Model -> Html Msg
view model =
  div [id "app", class "section"]
    [ div [class "container"]
      [editor model]
    ]

editor : Model -> Html msg
editor model =
  inside
    ["field", "control"]
    ( textarea
      [ cols 80, rows 12, class "textarea" ]
      []
    )

inside : List String -> Html msg -> Html msg
inside classes content =
  case (List.reverse classes) of
    className :: more ->
      inside more (div [class className] [content])
    
    [] ->
      content


-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions _ =
  htmlSource CompiledHtml
