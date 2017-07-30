port module Port exposing (..)

import Model.Quiz exposing (DraftQuiz, QuizFromServer)
import Port.Utils exposing (..)


port addQuiz : DraftQuiz -> Cmd msg


port alert : String -> Cmd msg


port addQuizResult : (ServerResult QuizFromServer -> msg) -> Sub msg
