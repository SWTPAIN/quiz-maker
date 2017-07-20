module Model exposing (..)

import Model.Quiz exposing (Quiz)
import QuizWizard.Model as QuizWizardModel


type alias Model =
    { quizzes : List Quiz
    , quizWizard : QuizWizardModel.Model
    }


initialModel : Model
initialModel =
    { quizzes =
        [ { question = "Why would people go vegan?"
          , choices =
                [ { content = "Killing animals is not humane", isCorrect = False }
                , { content = "Eating meat cause huge environmental problem", isCorrect = False }
                , { content = "Above all are correct", isCorrect = False }
                ]
          }
        , { question = "Inside which HTML element do we put the JavaScript?"
          , choices =
                [ { content = "<scripting>", isCorrect = False }
                , { content = "<js>", isCorrect = False }
                , { content = "<script>", isCorrect = True }
                , { content = "<javascript> ", isCorrect = False }
                ]
          }
        ]
    , quizWizard = QuizWizardModel.initialModel
    }


type Msg
    = QuizWizardMsg QuizWizardModel.Msg
