module Model.Shared exposing (..)


type alias Error =
    String



--- server


type alias ServerResult a =
    Result Error a
