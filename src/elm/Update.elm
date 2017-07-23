module Update exposing (..)

import Model exposing (Msg(..), Model)
import QuizWizard.Update as QuizWizardUpdate
import QuizWizard.Model as QuizWizardModel


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        QuizWizardMsg quizWizardMsg ->
            case quizWizardMsg of
                QuizWizardModel.CreateQuiz quiz ->
                    ( { model
                        | quizWizard = QuizWizardModel.initialModel
                        , quizzes = quiz :: model.quizzes
                        , notification = Just "Your quiz is created"
                      }
                    , Cmd.none
                    )

                _ ->
                    let
                        ( quizWizard, cmd ) =
                            QuizWizardUpdate.update quizWizardMsg model.quizWizard
                    in
                        ( { model
                            | quizWizard = quizWizard
                          }
                        , Cmd.map QuizWizardMsg cmd
                        )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


init : ( Model, Cmd Msg )
init =
    ( Model.initialModel, Cmd.none )
