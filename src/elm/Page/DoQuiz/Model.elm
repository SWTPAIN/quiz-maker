module Page.DoQuiz.Model exposing (..)

import Model.Quiz exposing (QuizWithChoosenAnswer, Quiz)


type alias Model =
    { quizWithChoosenAnswer : Maybe QuizWithChoosenAnswer
    }


initialModel : Maybe Quiz -> Model
initialModel maybeQuiz =
    case maybeQuiz of
        Nothing ->
            { quizWithChoosenAnswer = Nothing }

        Just quiz ->
            let
                questions =
                    List.map (\question -> { title = question.title, correctAnswer = question.correctAnswer, wrongAnswers = question.wrongAnswers, selectedAnswer = Nothing }) quiz.questions
            in
                { quizWithChoosenAnswer = Just { quiz | questions = questions }
                }


type Msg
    = UpdateAnswer Int String
    | Submit
