module Page.Home.Update exposing (..)

import Page.Home.Model exposing (..)
import QuizWizard.Model as QuizWizardModel
import QuizWizard.Update as QuizWizardUpdate
import Port


update : Msg -> Model -> ( Model, Cmd Msg )
update msg ({ quizWizard } as model) =
    case msg of
        QuizWizardMsg quizWizardMsg ->
            case quizWizardMsg of
                QuizWizardModel.CreateQuiz quiz ->
                    let
                        newQuizWizard =
                            { quizWizard | isCreating = True }
                    in
                        ( { model
                            | quizWizard =
                                newQuizWizard
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
