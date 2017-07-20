module QuizWizard.Update exposing (..)

import QuizWizard.Model exposing (Model, Msg(..))


update : Msg -> Model -> Model
update msg model =
    case msg of
        UpdateTitle title ->
            { model
                | title = Just title
            }
