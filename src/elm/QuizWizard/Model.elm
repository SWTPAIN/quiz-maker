module QuizWizard.Model exposing (..)

import Model.Quiz exposing (Question, Quiz)
import Model.Shared exposing (Error)


type alias Model =
    { title :
        String
    , questions : List Question
    , currentQuestionField :
        QuestionField
    , error : Maybe Error
    , currentStep : Step
    }


getQuestions : Model -> List Question
getQuestions { questions } =
    questions


type Step
    = AddTitle
    | AddQuestion


type alias QuestionField =
    { title : String
    , correctAnswer : String
    , prevWrongAnswers : List String
    , lastWrongAnswer : String
    }


questionToQuestionField : Question -> QuestionField
questionToQuestionField { title, correctAnswer, wrongAnswers } =
    let
        reversedWrongAnswers =
            List.reverse wrongAnswers

        lastWrongAnswer =
            reversedWrongAnswers |> List.head |> Maybe.withDefault ""

        prevWrongAnswers =
            reversedWrongAnswers |> List.drop 1 |> List.reverse
    in
        { title = title
        , correctAnswer = correctAnswer
        , prevWrongAnswers = prevWrongAnswers
        , lastWrongAnswer = lastWrongAnswer
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


defaultQuestionField : QuestionField
defaultQuestionField =
    { title = ""
    , correctAnswer = ""
    , prevWrongAnswers = []
    , lastWrongAnswer = ""
    }


initialModel : Model
initialModel =
    { title =
        ""
    , questions = []
    , currentQuestionField = defaultQuestionField
    , error = Nothing
    , currentStep = AddTitle
    }


type Msg
    = UpdateQuizTitle String
    | UpdateCurrentQuestionFieldMsg UpdateCurrentQuestionFieldMsg
    | StartAddQuestion
    | AddCurrentQuestion
    | CreateQuizRequest
    | CreateQuiz Quiz
    | BackStep


type UpdateCurrentQuestionFieldMsg
    = UpdateCurrentQuetionTitle String
    | UpdateCurrentQuestionCorrectAnswer String
    | UpdateCurrentQuestionPrevWrongAnswer Int String
    | UpdateCurrentQuestionLastWrongAnswer String
    | AddOneWrongQuestion
