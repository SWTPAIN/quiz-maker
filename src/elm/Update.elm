module Update exposing (..)

import Model exposing (Msg(..), Model)
import QuizWizard.Update as QuizWizardUpdate
import QuizWizard.Model as QuizWizardModel
import Port
import Route exposing (..)
import Navigation


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
                    , Port.addQuiz quiz
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

        MountRoute route ->
            mountRoute route model


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


init : Model.Flags -> Navigation.Location -> ( Model, Cmd Msg )
init flags location =
    mountRoute (Route.parser location) (Model.initialModel flags)


mountRoute : Route -> Model -> ( Model, Cmd Msg )
mountRoute newRoute model =
    ( { model
        | route = newRoute
      }
    , Cmd.none
    )
