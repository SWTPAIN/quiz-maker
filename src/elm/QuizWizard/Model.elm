module QuizWizard.Model exposing (..)

import Model.Quiz exposing (Question, Quiz)
import Model.Shared exposing (Error)


type alias Model =
    { title : String
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
    { title : String
    , correctAnswer : String
    , prevWrongAnswers : List String
    , lastWrongAnswer : String
    }


getWrongAnswers : QuestionField -> Result Error (List String)
getWrongAnswers { prevWrongAnswers, lastWrongAnswer } =
    let
        step ele acc =
            case ele of
                "" ->
                    Err "No answer can be empty."

                x ->
                    Result.map ((::) x) acc
    in
        List.foldr step (Ok []) (prevWrongAnswers ++ [ lastWrongAnswer ])


defaultQuestionFeild : QuestionField
defaultQuestionFeild =
    { title = ""
    , correctAnswer = ""
    , prevWrongAnswers = []
    , lastWrongAnswer = ""
    }


initialModel : Model
initialModel =
    { title = ""
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
    | CreateQuizRequest
    | CreateQuiz Quiz
    | NavigationMsg NavigationMsg


type UpdateCurrentQuestionFieldMsg
    = UpdateCurrentQuetionTitle String
    | UpdateCurrentQuestionCorrectAnswer String
    | UpdateCurrentQuestionPrevWrongAnswer Int String
    | UpdateCurrentQuestionLastWrongAnswer String
    | AddOneWrongQuestion


type NavigationMsg
    = NextPage
