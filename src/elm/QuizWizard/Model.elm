module QuizWizard.Model exposing (..)

import Model.Quiz exposing (Question)
import Model.Shared exposing (Error)


type alias Model =
    { title : Maybe String
    , questions : List Question
    , currentQuestionField :
        QuestionField
    , error : Maybe Error
    , navigationHistory : NavigationHistory
    }


type Step
    = AddTitle
    | AddQuestions


type alias NavigationHistory =
    { previous : List Step
    , current : Step
    , remaining : List Step
    }


initialnavigationHistory : NavigationHistory
initialnavigationHistory =
    { previous = []
    , current = AddTitle
    , remaining = [ AddQuestions ]
    }


type alias QuestionField =
    { title : Maybe String
    , correctAnswer : Maybe String
    , prevWrongAnswers : List (Maybe String)
    , lastWrongAnswer : Maybe String
    }


getWrongAnswers : QuestionField -> Result Error (List String)
getWrongAnswers { prevWrongAnswers, lastWrongAnswer } =
    let
        step ele acc =
            case ele of
                Nothing ->
                    Err "No answer can be empty."

                Just x ->
                    Result.map ((::) x) acc
    in
        List.foldr step (Ok []) (prevWrongAnswers ++ [ lastWrongAnswer ])


defaultQuestionFeild : QuestionField
defaultQuestionFeild =
    { title = Nothing
    , correctAnswer = Nothing
    , prevWrongAnswers = []
    , lastWrongAnswer = Nothing
    }


initialModel : Model
initialModel =
    { title = Nothing
    , questions = []
    , currentQuestionField = defaultQuestionFeild
    , error = Nothing
    , navigationHistory = initialnavigationHistory
    }


type Msg
    = UpdateQuizTitle String
    | UpdateCurrentQuestionFieldMsg UpdateCurrentQuestionFieldMsg
    | StartAddQuestion
    | AddCurrentQuestion
    | NavigationMsg NavigationMsg


type UpdateCurrentQuestionFieldMsg
    = UpdateCurrentQuetionTitle String
    | UpdateCurrentQuestionCorrectAnswer String
    | UpdateCurrentQuestionPrevWrongAnswer Int String
    | UpdateCurrentQuestionLastWrongAnswer String
    | AddOneWrongQuestion


type NavigationMsg
    = NextPage
