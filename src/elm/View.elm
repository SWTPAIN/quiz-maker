module View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Model exposing (Model, Msg(..))
import Model.Quiz exposing (Quiz, Question)
import QuizWizard.View as QuizWizardView


view : Model -> Html Msg
view { quizzes, quizWizard, notification } =
    div []
        [ notificationView notification
        , div [ class "columns" ]
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
    div [ class "container" ]
        [ div [ class "section" ]
            [ a [ class "title" ] [ p [] [ text quiz.title ] ]
            ]
        ]


questionView : Question -> Html Msg
questionView { title } =
    div [] [ text title ]


notificationView : Maybe String -> Html Msg
notificationView maybeNotification =
    case maybeNotification of
        Nothing ->
            div [] []

        Just error_ ->
            div [ class "notification is-success" ]
                [ text error_
                ]
