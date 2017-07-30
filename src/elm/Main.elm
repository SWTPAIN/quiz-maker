module Main exposing (..)

import Model exposing (Model, Msg, Flags)
import View
import Update
import Navigation
import Route


main : Program Flags Model Msg
main =
    Navigation.programWithFlags
        (Route.parser >> Model.MountRoute)
        { init = Update.init
        , view = View.view
        , update = Update.update
        , subscriptions = Update.subscriptions
        }
