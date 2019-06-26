port module Main exposing (main)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)



-- PORTS & EXPORTS


{-| Request JS to compile markdown string into HTML markup.

    Outgoing.

-}
port compileMarkdown : String -> Cmd msg


{-| Request JS to update `innerHTML` props under
virtual nodes which Elm controls.

    Outgoing.

-}
port requestPreview : () -> Cmd msg


{-| Start running program.
-}
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
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { showSource = False }
    , Cmd.none
    )



-- UPDATE


type Msg
    = Markdown String
    | ShowSource Bool


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Markdown mdText ->
            ( model
            , Cmd.batch
                [ compileMarkdown mdText
                , requestPreview ()
                ]
            )

        ShowSource newFlag ->
            ( { model | showSource = newFlag }
            , requestPreview ()
            )



-- VIEW


view : Model -> Html Msg
view model =
    section
        [ id "app", class "section" ]
        [ div
            [ class "container is-fluid" ]
            [ div
                [ class "field" ]
                [ showSourceSwitch
                , label [ class "label" ] [ text "Markdown" ]
                , editor
                ]
            , preview model
            ]
        ]


showSourceSwitch : Html Msg
showSourceSwitch =
    inside [ "control" ] <|
        label
            [ class "checkbox" ]
            [ input
                [ type_ "checkbox"
                , onCheck ShowSource
                ]
                []
            , text "View HTML source"
            ]


preview : Model -> Html Msg
preview { showSource } =
    div
        [ class "content"
        , id "preview"
        ]
        [ pre
            [ class "preview-content"
            , hidden <| not showSource
            ]
            []
        , div
            [ class "preview-content"
            , hidden showSource
            ]
            []
        ]


editor : Html Msg
editor =
    let
        attrs =
            [ cols 80
            , rows 12
            , class "textarea"
            , onInput Markdown
            ]
    in
    inside [ "control" ] <| textarea attrs []


inside : List String -> Html msg -> Html msg
inside classes content =
    case List.reverse classes of
        [] ->
            content

        className :: more ->
            inside more (div [ class className ] [ content ])



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none
