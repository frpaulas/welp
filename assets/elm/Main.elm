module Main exposing (main)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onSubmit, onClick)
import Views.Form as Form
import Json.Decode exposing (string, int, list, Decoder, at)
import Json.Decode.Pipeline exposing (decode, required)
import Http
import Dom
import Task
import Autocomplete
import AutocompleteWrapper
import Debug


-- MAIN --


main : Program Never Model Msg
main =
    program
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }

-- MODELS -- 

type alias Section =
  { ofType : String
  , body : String
  , n : Int
  }

initSection : Section
initSection =
  { ofType = ""
  , body = ""
  , n = 0
  }


type alias Model =
  { newSection : Section
  , sections : List Section
  , editingSection : Bool
  -- , ofTypes : List String
  , ofTypeMenu : AutocompleteWrapper.Model
  }

initModel : Model
initModel = 
  { newSection = initSection
  , sections = []
  , editingSection = False
  -- , ofTypes = ["title", "rubric", "plaintext"]
  , ofTypeMenu = AutocompleteWrapper.init "of-types" "Section" ofTypeItems
  }

ofTypeItems : List AutocompleteWrapper.MenuItem
ofTypeItems =
  ["title", "rubric", "plaintext"]

init : (Model, Cmd Msg)
init = 
  (initModel, Cmd.none)


-- SUBSCRIPTIONS --

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.batch
    [ Sub.map (OriginMessage model.ofTypeMenu.id <<
        AutocompleteWrapper.SetAutoState) Autocomplete.subscription]

-- UPDATE --

type Msg
  = Noop
  | Edit Section
  | FocusOn String
  | FocusResult (Result Dom.Error ())
  | OriginMessage String AutocompleteWrapper.Msg
  | Save
  | SetSectionType String
  | SetBody String


update : Msg -> Model -> (Model, Cmd Msg)
update msg model = 
  let
    msgConverter : Msg -> (String, AutocompleteWrapper.Msg)
    msgConverter msg =
      case msg of
        OriginMessage fieldId autocomMsg ->
          (fieldId, autocomMsg)
        _ -> ("", AutocompleteWrapper.NoOpAutocom)

  in
      
  case msg of

    OriginMessage fieldId autocomMsg ->
      if fieldId == model.ofTypeMenu.id then
        let
          (newModel, newMsg) =
            AutocompleteWrapper.update autocomMsg
            model.ofTypeMenu OriginMessage msgConverter

          _ = Debug.log "debug 113: " newMsg
          _ = Debug.log "debug 114: " newModel
          section = model.newSection
          newSection = { section | ofType = newModel.value }

        in
        ({ model | ofTypeMenu = newModel, newSection = newSection }, newMsg)
      else
        (model, Cmd.none)

    Noop ->
      (model, Cmd.none)

    Edit section ->
      ({model | newSection = section}, Cmd.none)

    FocusOn id ->
      (model, Dom.focus id |> Task.attempt FocusResult)

    FocusResult result -> 
      case result of
        Err (Dom.NotFound id) -> 
          let
            _ =
              Debug.log "ID NOT FOUND: " id
          in
              
          (model, Cmd.none)
        Result.Ok () -> 
          let
            _ =
              Debug.log "ID WAS FOUND: " "REFOCUS"
          in
              
          (model, Cmd.none)

    Save -> 
      let
        newModel =
          { model | 
              sections = model.sections ++ [model.newSection],
              newSection = initSection,
              editingSection = False
          }
        _ = Debug.log "debug 79:" newModel
        _ = Dom.focus "inputOfType"
      in
        (newModel, Cmd.none)

    SetSectionType sectionType ->
      let
        section = model.newSection
        newSection = { section | ofType = sectionType }
        newModel = { model | newSection = newSection, editingSection = True }
          
      in
          
      (newModel, Cmd.none)
          
    SetBody body ->
      let
        section = model.newSection
        newSection = { section | body = body }
        newModel = { model | newSection = newSection, editingSection = True}
          
      in
          
      (newModel, Cmd.none)

-- VIEW --

view : Model -> Html Msg
view model =
  div [ class "body mw9 center ph3-n2"]
    [ div [class "cf ph2-ns"]
        (leftSide model :: [rightSide model])
    , div [class "output"] [ output model ]
    ]

leftSide : Model -> Html Msg
leftSide model =
  div [class "leftSide fl w-100 w-50-ns pa2"]
    [viewForm model]

viewForm : Model -> Html Msg
viewForm model =
    let
        saveButtonText =
            if model.editingSection then
                "Next Section"
            else
                "Save All"
    in
    Html.form [ onSubmit Save ]
        [ fieldset []
            [ AutocompleteWrapper.view model.ofTypeMenu OriginMessage

            -- , Form.input
            --     [ class "form-control-lg"
            --     , id "inputOfType"
            --     , placeholder "Section Type"
            --     , onInput SetSectionType
            --     , value model.newSection.ofType
            --     ]
            --     []
            , Form.textarea
                [ placeholder "Enter Text"
                , attribute "rows" "8"
                , onInput SetBody
                , value model.newSection.body
                ]
                []
            , button [ class "btn btn-lg pull-xs-right btn-primary" ]
                [ text saveButtonText ]
            ]
        ]



rightSide : Model -> Html Msg
rightSide model = 
  div [class "rightSide fl w-100 w-50-ns pa2" ] 
  [ div [ class "outline bg-white pv4 pa2" ]
      (List.map singleSection (model.sections ++ [model.newSection]))
  ]

singleSection : Section -> Html Msg
singleSection section =
  div [ class section.ofType, onClick (Edit section) ] [ text section.body ]

output : Model -> Html Msg
output model =
  div []
    (List.map singleOutput (model.sections ++ [model.newSection]))

singleOutput : Section -> Html Msg
singleOutput section =
  let 
    line =
      "<" ++ section.ofType ++ ">" ++ section.body ++ "<\\" ++ section.ofType ++ ">"
  in
  p [] [ text line ]


