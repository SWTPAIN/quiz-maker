module Model exposing (..)

import Model.Quiz exposing (Quiz)
import QuizWizard.Model as QuizWizardModel
import Route exposing (Route)


type alias Flags =
    { quizzes : List Quiz }


type alias Model =
    { route : Route
    , quizzes : List Quiz
    , quizWizard : QuizWizardModel.Model
    , notification : Maybe String
    }


initialModel : Flags -> Model
initialModel { quizzes } =
    { route = Route.Home
    , quizzes = quizzes
    , quizWizard = QuizWizardModel.initialModel
    , notification = Nothing
    }


type Msg
    = QuizWizardMsg QuizWizardModel.Msg
    | MountRoute Route
