module Preview exposing (main)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)
import Markdown



main : Program () Model Msg
main =
    Browser.sandbox
        { init = init
        , view = view
        , update = update
        }



-- INIT


type alias Model =
    { source : String
    }


init : Model
init =
    Model ""



-- UPDATE


type Msg
    = NewInput String



update : Msg -> Model -> Model
update msg model =
    case msg of
        NewInput val ->
            { model | source = val }



-- VIEW


view : Model -> Html Msg
view model =
    div
        [ class "columns"
        , style "height" "100%"
        ]
        [ viewEditor
        , viewPreview model
        ]


viewEditor : Html Msg
viewEditor =
    div
        [ class "column" ]
        [ textarea
            [ style "resize" "none"
            , style "width" "100%"
            , style "height" "100%"
            , style "font-family" "monospace"
            , style "font-size" "1rem"
            , style "border" "0"
            , style "padding" "0.375rem"
            , onInput NewInput
            ]
            []
        ]


viewPreview : Model -> Html msg
viewPreview model =
    div
        [ class "column" ]
        [ if String.isEmpty model.source then
            text ""
          else
            Markdown.toHtml
                [ class "content" ]
                model.source
        ]