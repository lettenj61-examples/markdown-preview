port module Main exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


port markdownSource : String -> Cmd msg


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
  { fieldName : Maybe String }

init : () -> ( Model, Cmd Msg )
init _ =
  ( { fieldName = Nothing }
  , Cmd.none
  )


-- UPDATE

type Msg
  = NoOp

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    NoOp ->
      (model, Cmd.none)


-- VIEW

view : Model -> Html Msg
view model =
  div [] [ text "Hello, world!" ]


-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none
