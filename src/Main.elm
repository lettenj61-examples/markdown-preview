port module Main exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode as Decode
import Json.Encode as Encode


-- PORTS & EXPORTS

{-| Request JS to compile markdown string into HTML markup.

    Outgoing.
-}
port compileMarkdown : String -> Cmd msg

{-| Request JS to update `innerHTML` props under
    virtual nodes which Elm controls.

    Outgoing.
-}
port requestPreview : Bool -> Cmd msg

{-| Receive compiled HTML text from JavaScript.

    Incoming.
-}
port htmlSource : (String -> msg) -> Sub msg

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
  | ShowSource Bool

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    Markdown mdText ->
      ( model
      , compileMarkdown mdText
      )

    CompiledHtml result ->
      ( { model | htmlText = result }
      , requestPreview model.showSource
      )

    ShowSource newFlag ->
      ( { model | showSource = newFlag }
      , requestPreview model.showSource
      )


-- VIEW

view : Model -> Html Msg
view model =
  div [ id "app", class "section" ]
    [ div
      [ class "container" ]
      [ div
        [ class "field" ]
        [ showSourceSwitch
        , label [class "label"] [text "Markdown"]
        , editor
        ]
      , preview model
      ]
    ]

showSourceSwitch : Html Msg
showSourceSwitch =
  inside ["control"] <|
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
preview { showSource, htmlText } =
  let
    previewNode =
      if showSource then
        pre
      else
        div
  in
  previewNode
    [ class "content"
    , id "preview"
    -- Elm will not edit `innerHTML` directly.
    -- https://github.com/elm/html/issues/172
    , attribute "data-render" htmlText
    ]
    []

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
  inside ["control"] <| textarea attrs []

inside : List String -> Html msg -> Html msg
inside classes content =
  case (List.reverse classes) of    
    [] ->
      content

    className :: more ->
      inside more (div [class className] [content])


-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions _ =
  htmlSource CompiledHtml
