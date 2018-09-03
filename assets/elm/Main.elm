port module Main exposing (main)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onSubmit, onClick)
import Views.Form as Form
-- import Json.Decode as Decode exposing (Decoder, Value)
-- import Json.Decode.Pipeline as Pipeline exposing (decode, required)
-- import Http
-- import Dom
-- import Task
-- import Autocomplete
-- import AutocompleteWrapper
import Debug
import String exposing (trim)
import Regex exposing(..)
import Json.Encode exposing (string)



-- MAIN --


main : Program Never Model Msg
main =
    program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }

-- PORTS --

port requestSelection : String -> Cmd msg

port requestedSelection : (Selection -> msg) -> Sub msg

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ requestedSelection RequestedSelection
        ]



-- MODELS -- 

type alias Selection =
  { ofType: String
  , text: String 
  }

type alias Model =
  { page: String
  , formattedPage: String
  }

initModel : Model
initModel = 
  { page = ""
  , formattedPage = ""
  }

init : (Model, Cmd Msg)
init = 
  (initModel, Cmd.none)


-- UPDATE --

type Msg
  = Noop
  | Edit String
  | Save
  | SetBody String
  | SetSectionType String
  | RequestedSelection Selection


update : Msg -> Model -> (Model, Cmd Msg)
update msg model = 
  case msg of

    Noop ->
      (model, Cmd.none)

    Edit page ->
      ({model | page = page, formattedPage = page}, Cmd.none)

    SetBody page ->
      let
        formattedPage =
          model.formattedPage
          |> replace All (regex "\n") (\_ -> "<br />")
          |> replace All (regex "<title>") (\_ -> "<div class=\"title\">")
          |> replace All (regex "</title>") (\_ -> "</div>")
          |> replace All (regex "<sectionTitle>") (\_ -> "<div class=\"sectionTitle\">")
          |> replace All (regex "</sectionTitle>") (\_ -> "</div>")
          |> replace All (regex "<rubric>") (\_ -> "<div class=\"rubric\">")
          |> replace All (regex "</rubric>") (\_ -> "</div>")
          |> replace All (regex "<reference>") (\_ -> "<span class=\"reference\">")
          |> replace All (regex "</reference>") (\_ -> "</span>")
          |> replace All (regex "<plaintext>") (\_ -> "<div class=\"plaintext\">")
          |> replace All (regex "</plaintext>") (\_ -> "</div>")
          |> replace All (regex "<indent>") (\_ -> "<span class=\"indent\">")
          |> replace All (regex "</indent>") (\_ -> "</span>")
         
      in
          
      ({model | page = formattedPage, formattedPage = page}, Cmd.none)

    SetSectionType ofType ->
      (model, Cmd.batch[ requestSelection ofType, Cmd.none ])

    Save -> 
      let
        _ = Debug.log "SAVE: " "DO SOME SAVING HERE..."
      in
        (model, Cmd.none)

    RequestedSelection selection ->
      let
        newModel = {model | formattedPage = tagify selection model}
      in
      (newModel, Cmd.none)


-- VIEW --

view : Model -> Html Msg
view model =
  div [ class "body mw9 center ph3-n2"]
    [ div [class "cf ph2-ns"]
      [ typeMenu
      , leftSide model
      , rightSide model
      ]
    , div [class "output"] [ output model ]
    ]

typeMenu : Html Msg
typeMenu =
  let
    btnClass = class "btn btn-sm pull-xs-right btn-primary"
      
  in
      
  div [class "fl w-100 w-10-ns pa2"]
      [ button [btnClass, onClick (SetSectionType "title")] [text "Title"]
      , button [btnClass, onClick (SetSectionType "sectionTitle")] [text "Section"]
      , button [btnClass, onClick (SetSectionType "rubric")] [text "Rubric"]
      , button [btnClass, onClick (SetSectionType "reference")] [text "Reference"]
      , button [btnClass, onClick (SetSectionType "plaintext")] [text "Plain text"]
      , button [btnClass, onClick (SetSectionType "indent")] [text "Indent"]
      ]

leftSide : Model -> Html Msg
leftSide model =
  div [class "leftSide fl w-100 w-50-ns pa2"]
    [viewForm model]

viewForm : Model -> Html Msg
viewForm model =
    Html.form [ onSubmit Save ]
        [ Form.textarea
            [ placeholder "Enter Text"
            , attribute "rows" "30"
            , onInput SetBody
            -- , value model.formattedPage
            , property  "innerHTML" <| string model.formattedPage 
            ]
            []
        , button [ class "btn btn-lg pull-xs-right btn-primary" ]
            [ text "Save" ]
        ]



rightSide : Model -> Html Msg
rightSide model = 
  let
    formattedPage =
      model.formattedPage
      |> replace All (regex "\n") (\_ -> "<br />")
      |> replace All (regex "<title>") (\_ -> "<div class=\"title\">")
      |> replace All (regex "</title>") (\_ -> "</div>")
      |> replace All (regex "<sectionTitle>") (\_ -> "<div class=\"sectionTitle\">")
      |> replace All (regex "</sectionTitle>") (\_ -> "</div>")
      |> replace All (regex "<rubric>") (\_ -> "<div class=\"rubric\">")
      |> replace All (regex "</rubric>") (\_ -> "</div>")
      |> replace All (regex "<reference>") (\_ -> "<span class=\"reference\">")
      |> replace All (regex "</reference>") (\_ -> "</span>")
      |> replace All (regex "<plaintext>") (\_ -> "<div class=\"plaintext\">")
      |> replace All (regex "</plaintext>") (\_ -> "</div>")
      |> replace All (regex "<indent>") (\_ -> "<span class=\"indent\">")
      |> replace All (regex "</indent>") (\_ -> "</span>")

  in
      
  div [class "rightSide fl w-100 w-40-ns pa2 bg-moon-gray" ] 
  -- following line takes raw html 
  [ div [ id "fpage", class "formattedPage outline bg-white pv4 pa2", property  "innerHTML" <| string formattedPage ]
      []
  ]

output : Model -> Html Msg
output model =
  div [] [text model.formattedPage]

tagify : Selection -> Model -> String
tagify select model =
  let
    selText = trim select.text
    replacementText = replace All (regex "\n") (\_ -> " ") selText
      
  in
      
  replace All 
    (regex selText) 
    (\_ -> "<" ++ select.ofType ++ ">" ++ replacementText ++ "</" ++ select.ofType ++ ">")
    model.formattedPage
    




