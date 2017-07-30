module Page.Home.Model exposing (..)

import QuizWizard.Model as QuizWizardModel


type alias Model =
    { quizWizard : QuizWizardModel.Model
    }


initialModel : Model
initialModel =
    { quizWizard = QuizWizardModel.initialModel }


type Msg
    = QuizWizardMsg QuizWizardModel.Msg
