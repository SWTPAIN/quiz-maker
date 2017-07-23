module QuizWizard.View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import QuizWizard.Model
    exposing
        ( Model
        , Msg(..)
        , UpdateCurrentQuestionFieldMsg(..)
        , QuestionField
        , Step(..)
        , getQuestions
        )


view : Model -> Html Msg
view model =
    div [ class "panel" ]
        [ div [ class "panel-heading" ] [ text "Create your own quiz" ]
        , div [ class "panel-block" ]
            [ div [ class "section" ]
                [ div [ class "title" ] [ p [] [ model |> title |> text ] ]
                , div []
                    [ notification model
                    , form model
                    ]
                , footer model
                ]
            ]
        ]


footer : Model -> Html Msg
footer model =
    case model.currentStep of
        AddTitle ->
            div [ class "card-footer" ]
                [ div [ class "card-footer-item" ]
                    [ div
                        [ class "button is-primary is-outlined"
                        , onClick StartAddQuestion
                        ]
                        [ text "Next" ]
                    ]
                ]

        AddQuestion ->
            div []
                [ div []
                    [ div
                        [ class "button is-outlined"
                        , onClick BackStep
                        ]
                        [ text "Back" ]
                    ]
                , div []
                    [ div
                        [ class "button is-primary is-outlined"
                        , onClick AddCurrentQuestion
                        ]
                        [ text "Add Question" ]
                    ]
                , div []
                    [ div
                        [ class "button is-success is-outlined"
                        , onClick CreateQuizRequest
                        ]
                        [ text "Create Quiz" ]
                    ]
                ]


notification : Model -> Html Msg
notification { error } =
    case error of
        Nothing ->
            div [] []

        Just error_ ->
            div [ class "notification is-danger" ]
                [ text error_
                ]


title : Model -> String
title ({ currentQuestionField, currentStep } as model) =
    case currentStep of
        AddTitle ->
            "What's the quiz title?"

        AddQuestion ->
            let
                currentQuestionCount =
                    model |> getQuestions |> List.length |> (+) 1 |> toString
            in
                "What's the question " ++ currentQuestionCount ++ " title"


form : Model -> Html Msg
form { title, currentQuestionField, currentStep } =
    let
        formContent =
            case currentStep of
                AddTitle ->
                    quizTitleForm title

                AddQuestion ->
                    quizQuestionForm currentQuestionField |> Html.map UpdateCurrentQuestionFieldMsg
    in
        Html.form []
            [ formContent
            ]


quizTitleForm : String -> Html Msg
quizTitleForm title =
    div [ class "field" ]
        [ div [ class "control" ]
            [ input
                [ class "input"
                , type_ "text"
                , placeholder "Quiz Title"
                , onInput UpdateQuizTitle
                , value title
                ]
                []
            ]
        ]


quizQuestionForm : QuestionField -> Html UpdateCurrentQuestionFieldMsg
quizQuestionForm { title, correctAnswer, prevWrongAnswers, lastWrongAnswer } =
    div []
        ([ div [ class "field" ]
            [ label [ class "label" ] [ text "What's the question?" ]
            , div [ class "control" ]
                [ input
                    [ class "input"
                    , type_ "text"
                    , placeholder "Question Title"
                    , onInput UpdateCurrentQuetionTitle
                    , value title
                    ]
                    []
                ]
            ]
         , div [ class "field" ]
            [ label [ class "label" ] [ text "What's the correct answer?" ]
            , div [ class "control" ]
                [ input
                    [ class "input"
                    , type_ "text"
                    , placeholder "Correct answer"
                    , onInput UpdateCurrentQuestionCorrectAnswer
                    , value correctAnswer
                    ]
                    []
                ]
            ]
         ]
            ++ List.indexedMap (\index ans -> wrongAnswerField ("What's the wrong answer " ++ (toString (index + 1)) ++ " ?") (UpdateCurrentQuestionPrevWrongAnswer index) ans) prevWrongAnswers
            ++ [ wrongAnswerField ("What's the wrong answer " ++ (prevWrongAnswers |> List.length |> ((+) 1) |> toString) ++ " ?") UpdateCurrentQuestionLastWrongAnswer lastWrongAnswer ]
            ++ [ div
                    [ class "button is-outlined"
                    , onClick AddOneWrongQuestion
                    ]
                    [ text "Add Wrong Question" ]
               ]
        )


wrongAnswerField : String -> (String -> UpdateCurrentQuestionFieldMsg) -> String -> Html UpdateCurrentQuestionFieldMsg
wrongAnswerField title msg wrongAnswer =
    div [ class "field" ]
        [ label [ class "label" ] [ text title ]
        , div [ class "control" ]
            [ input
                [ class "input"
                , type_ "text"
                , placeholder "Wrong answer"
                , onInput msg
                , value wrongAnswer
                ]
                []
            ]
        ]
