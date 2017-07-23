module Model exposing (..)

import Model.Quiz exposing (Quiz)
import QuizWizard.Model as QuizWizardModel


type alias Model =
    { quizzes : List Quiz
    , quizWizard : QuizWizardModel.Model
    , notification : Maybe String
    }


defaultQuizzes : List Quiz
defaultQuizzes =
    [ { title = "Vegan Quiz"
      , questions =
            [ { title = "Why would people go vegan?"
              , correctAnswer = "all are correct"
              , wrongAnswers =
                    [ "Killing animals is not humane"
                    , "Eating meat cause huge environmental problem"
                    ]
              }
            ]
      }
    , { title = "Javascript Quiz"
      , questions =
            [ { title = "Inside which HTML element do we put the JavaScript?"
              , correctAnswer = "<script>"
              , wrongAnswers =
                    [ "<scripting>"
                    , "<js>"
                    , "<javascript>"
                    ]
              }
            ]
      }
    ]


initialModel : Model
initialModel =
    { quizzes = defaultQuizzes
    , quizWizard = QuizWizardModel.initialModel
    , notification = Nothing
    }


type Msg
    = QuizWizardMsg QuizWizardModel.Msg
