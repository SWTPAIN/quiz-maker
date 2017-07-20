module Update exposing (..)

import Model exposing (Msg(..), Model)
import QuizWizard.Update as QuizWizardUpdate


update : Msg -> Model -> Model
update msg model =
    case msg of
        QuizWizardMsg quizWizardMsg ->
            { model
                | quizWizard = QuizWizardUpdate.update quizWizardMsg model.quizWizard
            }
