port module Port exposing (..)

import Model.Quiz exposing (Quiz)


port addQuiz : Quiz -> Cmd msg


port addQuizResult : Quiz -> Cmd msg
