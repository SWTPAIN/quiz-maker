module QuizWizard.Model exposing (..)

import Model.Quiz exposing (Quiz)


type alias Model =
    { title : Maybe String
    , choices : List Quiz
    }


initialModel : Model
initialModel =
    { title = Nothing
    , choices = []
    }


type Msg
    = UpdateTitle String
