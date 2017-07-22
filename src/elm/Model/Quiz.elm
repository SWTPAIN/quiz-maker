module Model.Quiz exposing (..)


type alias Quiz =
    { title : String
    , questions : List Question
    }


type alias Question =
    { title : String
    , correctAnswer : String
    , wrongAnswers : List String
    }
