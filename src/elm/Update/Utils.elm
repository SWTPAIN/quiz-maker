module Update.Utils exposing (..)

import Task exposing (Task)


msgToCmd : msg -> Cmd msg
msgToCmd msg =
    Task.perform identity (Task.succeed msg)
