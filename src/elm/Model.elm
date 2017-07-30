module Model exposing (..)

import Model.Quiz exposing (Quiz)
import Model.Shared exposing (ServerResult)
import Page.DoQuiz.Model as DoQuizModel
import Page.Home.Model as HomeModel
import Route exposing (Route)


type alias Flags =
    { quizzes : List Quiz }


type alias Model =
    { route : Route
    , quizzes : List Quiz
    , notification : Maybe String
    , doQuiz : DoQuizModel.Model
    , home : HomeModel.Model
    }


initialModel : Flags -> Model
initialModel { quizzes } =
    { route = Route.Home
    , quizzes = quizzes
    , notification = Nothing
    , doQuiz = DoQuizModel.initialModel Nothing
    , home = HomeModel.initialModel
    }


type Msg
    = MountRoute Route
    | AddQuizResult (ServerResult Quiz)
    | DoQuizMsg DoQuizModel.Msg
    | HomeMsg HomeModel.Msg
    | CloseNotification
