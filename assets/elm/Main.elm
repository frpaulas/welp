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
  , readingsOpen: Bool
  }

initModel : Model
initModel = 
  { json = []
  , formattedPage = ""
  , readingsOpen = False
  }

init : (Model, Cmd Msg)
init = 
  (initModel, Cmd.none)

type Reading
  = MP1
  | MP2
  | MPsalms
  | EP1
  | EP2
  | EPsalms
  | OT
  | PS
  | NT
  | GS


-- UPDATE --

type Msg
  = Noop
  | Edit String
  | Save
  | SetBody String
  | SetSectionType String
  | SetReading Reading
  | ShowReading
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
        _ = Debug.log "SET BODY: " page
--        formattedPage =
--          model.formattedPage
--          |> replace All (regex "\n") (\_ -> "<br />")
--          |> replace All (regex "<title>") (\_ -> "<div class=\"title\">")
--          |> replace All (regex "</title>") (\_ -> "</div>")
--          |> replace All (regex "<sectionTitle>") (\_ -> "<div class=\"sectionTitle\">")
--          |> replace All (regex "</sectionTitle>") (\_ -> "</div>")
--          |> replace All (regex "<rubric>") (\_ -> "<div class=\"rubric\">")
--          |> replace All (regex "</rubric>") (\_ -> "</div>")
--          |> replace All (regex "<reference>") (\_ -> "<span class=\"reference\">")
--          |> replace All (regex "</reference>") (\_ -> "</span>")
--          |> replace All (regex "<plaintext>") (\_ -> "<div class=\"plaintext\">")
--          |> replace All (regex "</plaintext>") (\_ -> "</div>")
--          |> replace All (regex "<indent>") (\_ -> "<span class=\"indent\">")
--          |> replace All (regex "</indent>") (\_ -> "</span>")

      in
      (model, Cmd.none)
          
--      ({model | formattedPage = page}, Cmd.none)

    SetSectionType ofType ->
      (model, Cmd.batch[ requestSelection ofType, Cmd.none ])

    Save -> 
      let
        _ = Debug.log "SAVE: " "DO SOME SAVING HERE..."
      in
        (model, Cmd.none)

    SetReading ofType ->
      let
        newModel = {model | readingsOpen = False}
      in
      (newModel, Cmd.none)
          

    ShowReading ->
      ({model | readingsOpen = not model.readingsOpen}, Cmd.none)

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
  [ typeMenu model
  , readingOptions model
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

typeMenu : Model -> Html Msg
typeMenu model =
  let
    btnClass = class "btn btn-sm pull-xs-right btn-primary w-80"
    inactive = class "btn btn-sm pull-xs-right btn-primary w-80 o-50"
    danger = class "btn btn-sm pull-xs-right btn-primary w-80 hover-bg-dark-red"
    showClass = 
        if model.readingsOpen then
          class "dn"
        else
          class "fl w-100 w-10-ns pa2"
      
  in
      
  div [ showClass ]
      [ button [inactive, onClick (SetSectionType "meta")] [text "Meta Data"]
      , button [btnClass, onClick (SetSectionType "title")] [text "Title ^T"]
      , button [btnClass, onClick (SetSectionType "sectionTitle")] [text "Section ^C"]
      , button [btnClass, onClick (SetSectionType "rubric")] [text "Rubric ^R"]
      , button [btnClass, onClick (SetSectionType "reference")] [text "Reference ^F"]
      , button [btnClass, onClick (SetSectionType "plaintext")] [text "Plain text ↩"]
      , button [btnClass, onClick (SetSectionType "indent")] [text "Indent ^I"]
      , button [btnClass, onClick (SetSectionType "scripture")] [text "Scripture ^S"]
      , button [inactive, onClick (SetSectionType "versicals")] [text "Versicals ^V"]
      , button [inactive, onClick (SetSectionType "psalm")] [text "Psalm ^P"]
      , button [inactive, onClick (SetSectionType "psalm")] [text "Call/Resp ^R"]
      , button [btnClass, onClick ShowReading ] [text "Reading"]
      , button [danger, onClick (SetSectionType "delete")] [text "Delete"]
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
            , onInput SetBody
            -- , value model.formattedPage
            -- , property  "val" <| string model.page
            ]
            []
        , button [ class "btn btn-lg pull-xs-right btn-primary o-50" ]
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
    

readingOptions : Model -> Html Msg
readingOptions model =
  let
    btnClass = class "btn btn-sm pull-xs-right btn-primary w-80"
    showClass = if  model.readingsOpen then
        class "dib fl w-100 w-10-ns pa2 z-5"
      else
        class "dn"
  in
      
  div [ showClass ]
      [ button [btnClass, onClick (SetReading MP1)] [text "MP Lesson 1"]
      , button [btnClass, onClick (SetReading MP2)] [text "MP Lesson 2"]
      , button [btnClass, onClick (SetReading MPsalms)] [text "MP Psalms"]
      , button [btnClass, onClick (SetReading EP1)] [text "EP Lesson 1"]
      , button [btnClass, onClick (SetReading EP2)] [text "EP Lesson 2"]
      , button [btnClass, onClick (SetReading EPsalms)] [text "EP Psalms"]
      , button [btnClass, onClick (SetReading OT)] [text "Euch. OT"]
      , button [btnClass, onClick (SetReading NT)] [text "Euch. NT"]
      , button [btnClass, onClick (SetReading PS)] [text "Euch. Psalm"]
      , button [btnClass, onClick (SetReading GS)] [text "Euch. Gospel"]
      , button [btnClass, onClick ShowReading] [text "CANCEL"]
      ]



