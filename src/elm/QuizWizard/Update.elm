module QuizWizard.Update exposing (..)

import Model.Quiz exposing (Question, Quiz)
import Update.Utils exposing (msgToCmd)
import QuizWizard.Model
    exposing
        ( Model
        , Msg(..)
        , UpdateCurrentQuestionFieldMsg(..)
        , Step(..)
        , QuestionField
        , defaultQuestionField
        , getWrongAnswers
        , getQuestions
        , questionToQuestionField
        )
import Model.Shared exposing (Error)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UpdateQuizTitle title ->
            ( { model
                | title = title
              }
            , Cmd.none
            )

        UpdateCurrentQuestionFieldMsg updateCurrentQuestionFieldMsg ->
            ( { model
                | currentQuestionField = updateCurrentQuestionField updateCurrentQuestionFieldMsg model.currentQuestionField
              }
            , Cmd.none
            )

        StartAddQuestion ->
            case getTitle model of
                Err err ->
                    ( { model | error = Just err }, Cmd.none )

                Ok _ ->
                    ( { model
                        | currentQuestionField =
                            defaultQuestionField
                        , error = Nothing
                        , currentStep = AddQuestion
                      }
                    , Cmd.none
                    )

        AddCurrentQuestion ->
            case getCurrentQuestion model.currentQuestionField of
                Err err ->
                    { model | error = Just err } ! [ Cmd.none ]

                Ok question ->
                    { model
                        | questions = model.questions ++ [ question ]
                        , currentQuestionField = defaultQuestionField
                        , error = Nothing
                    }
                        ! [ Cmd.none ]

        CreateQuiz quiz ->
            ( model, Cmd.none )

        CreateQuizRequest ->
            case getCurrentQuestion model.currentQuestionField of
                Err err ->
                    { model | error = Just err } ! [ Cmd.none ]

                Ok question ->
                    case getQuiz { model | questions = model.questions ++ [ question ] } of
                        Ok quiz ->
                            ( model, CreateQuiz quiz |> msgToCmd )

                        Err err ->
                            { model | error = Just err } ! [ Cmd.none ]

        BackStep ->
            case List.reverse model.questions of
                [] ->
                    { model
                        | error = Nothing
                        , currentStep = AddTitle
                        , questions = []
                        , currentQuestionField = defaultQuestionField
                    }
                        ! [ Cmd.none ]

                lastQ :: restQs ->
                    { model
                        | error = Nothing
                        , questions = restQs
                        , currentQuestionField = questionToQuestionField lastQ
                    }
                        ! [ Cmd.none ]


getTitle : Model -> Result Error String
getTitle { title } =
    case title of
        "" ->
            Err "Quiz Title cannnot be empty"

        title_ ->
            Ok title_


getQuiz : Model -> Result Error Quiz
getQuiz ({ title, questions } as model) =
    getTitle model
        |> Result.map (\title -> { title = title, questions = questions })


getCurrentQuestion : QuestionField -> Result Error Question
getCurrentQuestion ({ title, correctAnswer, prevWrongAnswers, lastWrongAnswer } as questionField) =
    Result.map3
        (\title correctAnswer wrongAnswers ->
            { title = title
            , correctAnswer = correctAnswer
            , wrongAnswers = wrongAnswers
            }
        )
        (if title == "" then
            Err "Question Title cannnot be empty"
         else
            Ok title
        )
        (if correctAnswer == "" then
            Err "Correct Answer cannot be empty"
         else
            Ok correctAnswer
        )
        (getWrongAnswers questionField)


updateCurrentQuestionField : UpdateCurrentQuestionFieldMsg -> QuestionField -> QuestionField
updateCurrentQuestionField updateCurrentQuestionFieldMsg questionField =
    case updateCurrentQuestionFieldMsg of
        UpdateCurrentQuetionTitle title ->
            { questionField
                | title = title
            }

        UpdateCurrentQuestionCorrectAnswer ans ->
            { questionField
                | correctAnswer = ans
            }

        UpdateCurrentQuestionPrevWrongAnswer index ans ->
            { questionField
                | prevWrongAnswers = updateCurrentQuestionWrongAnswers index ans questionField.prevWrongAnswers
            }

        UpdateCurrentQuestionLastWrongAnswer ans ->
            { questionField
                | lastWrongAnswer = ans
            }

        AddOneWrongQuestion ->
            { questionField
                | prevWrongAnswers = questionField.prevWrongAnswers ++ [ questionField.lastWrongAnswer ]
                , lastWrongAnswer = ""
            }


updateCurrentQuestionWrongAnswers : Int -> String -> List String -> List String
updateCurrentQuestionWrongAnswers targetIndex ans wrongAnswers =
    List.indexedMap
        (\index answer ->
            if targetIndex == index then
                ans
            else
                answer
        )
        wrongAnswers
