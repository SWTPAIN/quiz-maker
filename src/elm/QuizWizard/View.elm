module QuizWizard.View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import QuizWizard.Model exposing (Model, Msg)


-- import Model.Quiz exposing (Quiz, Choice)


view : Model -> Html Msg
view _ =
    div [ class "card" ]
        [ div [ class "card-header" ] [ p [ class "card-header-title" ] [ text "What's the quiz tittle?" ] ]
        , div [ class "card-content" ]
            [ Html.form []
                [ div [ class "field" ]
                    [ div [ class "control" ]
                        [ input [ class "input", type_ "text", placeholder "Quiz Title" ] []
                        ]
                    ]
                ]
            ]
        ]
