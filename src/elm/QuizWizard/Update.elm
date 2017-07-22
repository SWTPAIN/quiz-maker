module QuizWizard.Update exposing (..)

import Model.Quiz exposing (Question)
import QuizWizard.Model
    exposing
        ( Model
        , Msg(..)
        , UpdateCurrentQuestionFieldMsg(..)
        , NavigationMsg(..)
        , QuestionField
        , defaultQuestionFeild
        , getWrongAnswers
        , NavigationHistory
        )
import Model.Shared exposing (Error)


update : Msg -> Model -> Model
update msg model =
    case msg of
        UpdateQuizTitle title ->
            { model
                | title = Just title
            }

        UpdateCurrentQuestionFieldMsg updateCurrentQuestionFieldMsg ->
            { model
                | currentQuestionField = updateCurrentQuestionField updateCurrentQuestionFieldMsg model.currentQuestionField
            }

        NavigationMsg navigationMsg ->
            { model
                | navigationHistory = updateNavigationHistory navigationMsg model.navigationHistory
            }

        StartAddQuestion ->
            let
                newModel =
                    { model
                        | questions = []
                        , currentQuestionField =
                            defaultQuestionFeild
                    }
            in
                update (NavigationMsg NextPage) newModel

        AddCurrentQuestion ->
            addCurrentQuestion model


addCurrentQuestion : Model -> Model
addCurrentQuestion model =
    case getCurrentQuestion model.currentQuestionField of
        Ok currentQuestion ->
            { model
                | currentQuestionField =
                    defaultQuestionFeild
                , questions = model.questions ++ (List.singleton currentQuestion)
            }

        Err err ->
            { model
                | error = Just err
            }


getCurrentQuestion : QuestionField -> Result Error Question
getCurrentQuestion ({ title, correctAnswer, prevWrongAnswers, lastWrongAnswer } as questionField) =
    case title of
        Nothing ->
            Err "Title cannnot be empty"

        Just title_ ->
            case correctAnswer of
                Nothing ->
                    Err "Correct Answer cannot be empty"

                Just correctAnswer_ ->
                    case getWrongAnswers questionField of
                        Err err_ ->
                            Err err_

                        Ok wrongAnswers ->
                            Ok
                                { title = title_
                                , correctAnswer = correctAnswer_
                                , wrongAnswers = wrongAnswers
                                }


updateCurrentQuestionField : UpdateCurrentQuestionFieldMsg -> QuestionField -> QuestionField
updateCurrentQuestionField updateCurrentQuestionFieldMsg questionField =
    case updateCurrentQuestionFieldMsg of
        UpdateCurrentQuetionTitle title ->
            { questionField
                | title = Just title
            }

        UpdateCurrentQuestionCorrectAnswer ans ->
            { questionField
                | correctAnswer = Just ans
            }

        UpdateCurrentQuestionPrevWrongAnswer index ans ->
            { questionField
                | prevWrongAnswers = updateCurrentQuestionWrongAnswers index ans questionField.prevWrongAnswers
            }

        UpdateCurrentQuestionLastWrongAnswer ans ->
            { questionField
                | lastWrongAnswer = Just ans
            }

        AddOneWrongQuestion ->
            { questionField
                | prevWrongAnswers = questionField.prevWrongAnswers ++ [ questionField.lastWrongAnswer ]
                , lastWrongAnswer = Nothing
            }


updateCurrentQuestionWrongAnswers : Int -> String -> List (Maybe String) -> List (Maybe String)
updateCurrentQuestionWrongAnswers targetIndex ans wrongAnswers =
    List.indexedMap
        (\index answer ->
            if targetIndex == index then
                Just ans
            else
                answer
        )
        wrongAnswers


updateNavigationHistory : NavigationMsg -> NavigationHistory -> NavigationHistory
updateNavigationHistory navigationMsg ({ previous, current, remaining } as navigationHistory) =
    case navigationMsg of
        NextPage ->
            case remaining of
                [] ->
                    navigationHistory

                newCurrent :: newRemaining ->
                    { previous = (previous) ++ [ current ]
                    , current = newCurrent
                    , remaining = newRemaining
                    }
