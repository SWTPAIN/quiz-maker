module Model.Quiz exposing (..)


type alias Quiz =
    { question : String
    , choices : List Choice
    }


type alias Choice =
    { content : String
    , isCorrect : Bool
    }
