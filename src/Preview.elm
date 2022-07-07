module Preview exposing (main)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)
import Json.Decode as Decode exposing (Decoder, Value)
import Markdown


main : Program Value Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- INIT


type alias Model =
    { source : String
    , sanitize : Bool
    }


type alias Flags =
    { sanitize : Bool
    }


init : Value -> ( Model, Cmd msg )
init val =
    let
        sanitize =
            Decode.decodeValue flagDecoder val
                |> Result.map .sanitize
                |> Result.toMaybe
                |> Maybe.withDefault True
    in
    ( { source = ""
      , sanitize = sanitize
      }
    , Cmd.none
    )


flagDecoder : Decoder Flags
flagDecoder =
    Decode.field "sanitize" Decode.string
        |> Decode.andThen
            (\s ->
                case s of
                    "true" ->
                        Decode.succeed True

                    "false" ->
                        Decode.succeed False

                    _ ->
                        Decode.fail "sanitize must be `true` or `false`"
            )
        |> Decode.map Flags



-- UPDATE


type Msg
    = NewInput String


update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    case msg of
        NewInput val ->
            ( { model | source = val }
            , Cmd.none
            )



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
            Markdown.toHtmlWith
                (toMarkdownOptions model)
                [ class "content" ]
                model.source
        ]


toMarkdownOptions : Model -> Markdown.Options
toMarkdownOptions { sanitize } =
    let
        defaults =
            Markdown.defaultOptions
    in
    { defaults
        | sanitize = sanitize
    }



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none
