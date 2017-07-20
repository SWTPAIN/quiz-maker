module View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Model exposing (Model, Msg(..))
import Model.Quiz exposing (Quiz, Choice)
import QuizWizard.View as QuizWizardView


view : Model -> Html Msg
view { quizzes, quizWizard } =
    div [ class "columns" ]
        [ div [ class "column" ]
            [ Html.map QuizWizardMsg (QuizWizardView.view quizWizard) ]
        , div [ class "column" ]
            (List.map
                quizView
                quizzes
            )
        ]


quizView : Quiz -> Html Msg
quizView quiz =
    div [ class "card" ]
        [ div [ class "card-header" ] [ p [ class "card-header-title" ] [ text "Question" ] ]
        , div [ class "card-content" ] [ div [ class "content" ] [ text quiz.question ] ]
        , div [ class "card-footer" ] (List.map choiceView quiz.choices)
        ]


choiceView : Choice -> Html Msg
choiceView { content } =
    div [ class "card-footer-item" ] [ text content ]
