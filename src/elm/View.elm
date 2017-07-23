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
            [ div [ class "column" ]
                [ Html.map QuizWizardMsg (QuizWizardView.view quizWizard) ]
            , div [ class "column" ]
                (List.map
                    quizView
                    quizzes
                )
            ]
        ]


quizView : Quiz -> Html Msg
quizView quiz =
    div [ class "card" ]
        [ div [ class "card-header" ] [ p [ class "card-header-title" ] [ text "Question" ] ]
        , div [ class "card-content" ] [ div [ class "content" ] [ text quiz.title ] ]
        , div [ class "card-footer" ] (List.map questionView quiz.questions)
        ]


questionView : Question -> Html Msg
questionView { title } =
    div [ class "card-footer-item" ] [ text title ]


notificationView : Maybe String -> Html Msg
notificationView maybeNotification =
    case maybeNotification of
        Nothing ->
            div [] []

        Just error_ ->
            div [ class "notification is-success" ]
                [ text error_
                ]
