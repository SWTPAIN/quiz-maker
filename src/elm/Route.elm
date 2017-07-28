module Route exposing (..)

import RouteParser exposing (..)
import Navigation


parser : Navigation.Location -> Route
parser location =
    fromPath location.hash


type Route
    = Home
    | DoQuiz String
    | NotFound


fromPath : String -> Route
fromPath path =
    let
        a =
            Debug.log "aa" path
    in
        match matchers path
            |> Maybe.withDefault NotFound


matchers : List (Matcher Route)
matchers =
    [ static Home ""
    , dyn1 DoQuiz "#quizzes/" string ""
    ]


toPath : Route -> String
toPath route =
    case route of
        Home ->
            "/"

        DoQuiz id ->
            "#quizzes/" ++ id

        NotFound ->
            "/404"
