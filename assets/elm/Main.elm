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
port scrollDownRequest : String -> Cmd msg

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
  , selection: String
  }

type alias Model =
  { json: List String
  , formattedPage: String
  }

initModel : Model
initModel = 
  { json = []
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
      ({model | formattedPage = page}, Cmd.none)

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
          
      ({model | formattedPage = page}, Cmd.none)

    SetSectionType ofType ->
      (model, Cmd.batch[ requestSelection ofType, Cmd.none ])

    Save -> 
      let
        _ = Debug.log "SAVE: " "DO SOME SAVING HERE..."
      in
        (model, Cmd.none)

    RequestedSelection selection ->
      let
        _ = Debug.log "SELECTION: " selection

        -- newText = model.text
        newModel = {model | json = [selection.text] |> List.append model.json  }
      in
      (newModel, Cmd.batch[ scrollDownRequest "", Cmd.none ])


-- VIEW --

view : Model -> Html Msg
view model =
  div [ class ""]
  [ typeMenu
  , leftSide model
  , div [ id "preview", class "fl w-30 pa2 ba black b--white-70" ] [ ]
  , output model
  ]
--     [ div [class "cf ph2-ns"]
--       [ typeMenu
--       , leftSide model
-- --      , rightSide model
--       , div [id "preview", class "rightSide fl w-100 w-40-ns pa2 bg-moon-gray" ] []
--       ]
--     , div [class "output"] [ output model ]
--     ]

typeMenu : Html Msg
typeMenu =
  let
    btnClass = class "btn btn-sm pull-xs-right btn-primary w-80"
      
  in
      
  div [class "fl w-100 w-10-ns pa2"]
      [ button [btnClass, onClick (SetSectionType "title")] [text "Title"]
      , button [btnClass, onClick (SetSectionType "sectionTitle")] [text "Section"]
      , button [btnClass, onClick (SetSectionType "rubric")] [text "Rubric"]
      , button [btnClass, onClick (SetSectionType "reference")] [text "Reference"]
      , button [btnClass, onClick (SetSectionType "plaintext")] [text "Plain text"]
      , button [btnClass, onClick (SetSectionType "indent")] [text "Indent"]
      , button [btnClass, onClick (SetSectionType "scripture")] [text "Scripture"]
      , button [btnClass, onClick (SetSectionType "versicals")] [text "Versicals"]
      ]

leftSide : Model -> Html Msg
leftSide model =
  div [class "leftSide fl w-30 pa2 ba"]
    [viewForm model]

viewForm : Model -> Html Msg
viewForm model =
    Html.form [ onSubmit Save ]
        [ Form.textarea
            [ id "raw_office"
            , placeholder "Enter Text"
            , attribute "rows" "30"
            -- , onInput SetBody
            -- , value model.formattedPage
            -- , property  "val" <| string model.page
            ]
            []
        , button [ class "btn btn-lg pull-xs-right btn-primary" ]
            [ text "Save" ]
        ]



-- rightSide : Model -> Html Msg
-- rightSide model = 
--   let
--     formattedPage =
--       model.formattedPage
--       |> replace All (regex "\n") (\_ -> "<br />")
--       |> replace All (regex "<title>") (\_ -> "<div class=\"title\">")
--       |> replace All (regex "</title>") (\_ -> "</div>")
--       |> replace All (regex "<sectionTitle>") (\_ -> "<div class=\"sectionTitle\">")
--       |> replace All (regex "</sectionTitle>") (\_ -> "</div>")
--       |> replace All (regex "<rubric>") (\_ -> "<div class=\"rubric\">")
--       |> replace All (regex "</rubric>") (\_ -> "</div>")
--       |> replace All (regex "<reference>") (\_ -> "<span class=\"reference\">")
--       |> replace All (regex "</reference>") (\_ -> "</span>")
--       |> replace All (regex "<plaintext>") (\_ -> "<div class=\"plaintext\">")
--       |> replace All (regex "</plaintext>") (\_ -> "</div>")
--       |> replace All (regex "<indent>") (\_ -> "<span class=\"indent\">")
--       |> replace All (regex "</indent>") (\_ -> "</span>")
-- 
--   in
--       
--   div [class "rightSide fl w-100 w-40-ns pa2 bg-moon-gray" ] 
--   -- following line takes raw html 
--   [ div [ id "fpage", class "formattedPage outline bg-white pv4 pa2", property  "innerHTML" <| string formattedPage ]
--       []
--   ]

output : Model -> Html Msg
output model =
  let
    jsons j = p [ class "jsons" ] [ text j ]
  in     
  div [ id "rightSide", class "output fl w-25 light-silver bg-near-black pa2 ba b--white-70"] (List.map jsons model.json)

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
    




