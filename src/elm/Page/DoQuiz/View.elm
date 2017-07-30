module Page.DoQuiz.View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Page.DoQuiz.Model exposing (..)
import Model.Quiz exposing (..)
import Route


view : Model -> Html Msg
view { quizWithChoosenAnswer } =
    case quizWithChoosenAnswer of
        -- impossible. TODO better handling
        Nothing ->
            div [] []

        Just { title, questions } ->
            div [ class "container" ]
                [ h1 [ class "title" ] [ text title ]
                , div [] (List.indexedMap questionView questions)
                , div
                    [ class "button is-primary is-outlined"
                    , onClick Submit
                    ]
                    [ text "Submit" ]
                ]


quizView : Quiz -> Html Msg
quizView quiz =
    let
        path =
            Route.toPath (Route.DoQuiz quiz.id)
    in
        div [ class "container" ]
            [ div [ class "section" ]
                [ a
                    [ class "title"
                    , href path
                    , attribute "data-navigate" path
                    ]
                    [ p [] [ text quiz.title ] ]
                ]
            ]


questionView : Int -> QuestionWithSelectedAnswers -> Html Msg
questionView questionIndex { title, wrongAnswers, correctAnswer, selectedAnswer } =
    let
        answerView =
            \answer ->
                div [ class "control" ]
                    [ label [ class "radio" ]
                        [ input
                            [ type_ "radio"
                            , onClick (UpdateAnswer questionIndex answer)
                            , checked (selectedAnswer == Just answer)
                            ]
                            []
                        , text answer
                        ]
                    ]

        title_ =
            "Question " ++ toString (questionIndex + 1) ++ ". " ++ title
    in
        div [ class "box" ]
            [ h1 [ class "title" ] [ text title_ ]
            , div [ class "container" ]
                (List.map answerView (correctAnswer :: wrongAnswers))
            ]
