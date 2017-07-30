module Page.Home.View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Page.Home.Model exposing (..)
import Model.Quiz exposing (..)
import QuizWizard.View as QuizWizardView
import Route


view : List Quiz -> Model -> Html Msg
view quizzes { quizWizard } =
    div []
        [ div [ class "columns" ]
            [ div [ class "column is-half" ]
                [ Html.map QuizWizardMsg (QuizWizardView.view quizWizard) ]
            , div [ class "column" ]
                [ div [ class "panel" ]
                    [ div [ class "panel-heading" ]
                        [ text "Questions"
                        ]
                    , div [ class "panel-block" ]
                        [ div []
                            (List.map
                                quizView
                                quizzes
                            )
                        ]
                    ]
                ]
            ]
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
