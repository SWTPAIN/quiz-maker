module Page.DoQuiz.Update exposing (..)

import Page.DoQuiz.Model exposing (..)
import Model.Quiz exposing (Quiz, QuizWithChoosenAnswer)
import Port


mount : Quiz -> Model -> ( Model, Cmd Msg )
mount quiz model =
    ( initialModel (Just quiz), Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UpdateAnswer questionIndex answer ->
            let
                quiz =
                    model.quizWithChoosenAnswer
                        |> Maybe.map
                            (\quiz ->
                                { quiz
                                    | questions =
                                        (List.indexedMap
                                            (\index question ->
                                                if index == questionIndex then
                                                    { question
                                                        | selectedAnswer = Just answer
                                                    }
                                                else
                                                    question
                                            )
                                        )
                                            quiz.questions
                                }
                            )
            in
                ( { model
                    | quizWithChoosenAnswer = quiz
                  }
                , Cmd.none
                )

        Submit ->
            case model.quizWithChoosenAnswer of
                Nothing ->
                    ( model, Cmd.none )

                Just quiz ->
                    case validateAnswer quiz of
                        [] ->
                            ( model, Port.alert "Your answers are all correct!" )

                        wrongQuestionIndexs ->
                            ( model, wrongQuestionIndexs |> formatWrongAnswersMessage |> Port.alert )


formatWrongAnswersMessage : List Int -> String
formatWrongAnswersMessage indexs =
    "Your answers are wrong for "
        ++ List.foldr
            (\i acc -> acc ++ ("question " ++ toString (i + 1) ++ " "))
            ""
            indexs


validateAnswer : QuizWithChoosenAnswer -> List Int
validateAnswer { questions } =
    let
        go =
            \questions result index ->
                case questions of
                    [] ->
                        result

                    { correctAnswer, selectedAnswer } :: rest ->
                        go rest
                            (if Just correctAnswer == selectedAnswer then
                                result
                             else
                                index :: result
                            )
                            (index + 1)
    in
        go questions [] 0
