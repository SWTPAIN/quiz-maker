module View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Model exposing (Model, Msg(..))
import Model.Quiz exposing (Quiz, Question)
import QuizWizard.View as QuizWizardView
import Route


view : Model -> Html Msg
view { quizzes, quizWizard, notification, route } =
    case route of
        Route.Home ->
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

        Route.DoQuiz quizId ->
            div [] [ text quizId ]

        Route.NotFound ->
            div [] [ text "404 bye" ]


quizView : Quiz -> Html Msg
quizView quiz =
    let
        path =
            Route.toPath (Route.DoQuiz "abs")
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
