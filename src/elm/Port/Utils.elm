module Port.Utils exposing (..)

import Model.Shared as SharedModel exposing (..)


type alias ServerResult okResult =
    { err : Maybe Error, ok : Maybe okResult }


mapServerResult : ServerResult a -> SharedModel.ServerResult a
mapServerResult { err, ok } =
    case err of
        Just msg ->
            Err msg

        Nothing ->
            case ok of
                Nothing ->
                    Err "Unknown server error"

                Just ok_ ->
                    Ok ok_
