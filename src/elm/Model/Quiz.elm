module Model.Quiz exposing (..)


type alias DraftQuiz =
    { title : String
    , questions : List Question
    }


type alias Id =
    String


type alias WithId a =
    { a
        | id : Id
    }


type alias QuizWithChoosenAnswer =
    { id : Id
    , title : String
    , questions : List QuestionWithSelectedAnswers
    }


type alias Quiz =
    WithId DraftQuiz


type alias QuizFromServer =
    { title : String
    , questions : List Question
    , id : Id
    }


type alias Question =
    { title : String
    , correctAnswer : String
    , wrongAnswers : List String
    }


type alias WithSelectedAnswer a =
    { a
        | selectedAnswer : Maybe String
    }


type alias QuestionWithSelectedAnswers =
    WithSelectedAnswer Question
