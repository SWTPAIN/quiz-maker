module View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Model exposing (Model, Msg(..))
import Page.DoQuiz.View as PageDoQuiz
import Page.Home.View as PageHome
import Route


view : Model -> Html Msg
view ({ quizzes, route } as model) =
    let
        content =
            case route of
                Route.Home ->
                    Html.map HomeMsg (PageHome.view quizzes model.home)

                Route.DoQuiz quizId ->
                    Html.map DoQuizMsg (PageDoQuiz.view model.doQuiz)

                Route.NotFound ->
                    notFoundView
    in
        renderSite model content


renderSite : Model -> Html Msg -> Html Msg
renderSite { notification } content =
    div [ class "container" ]
        [ notificationView notification
        , content
        ]


notFoundView : Html Msg
notFoundView =
    div [ class "container" ]
        [ text "404 bye"
        ]


notificationView : Maybe String -> Html Msg
notificationView maybeNotification =
    case maybeNotification of
        Nothing ->
            div [] []

        Just error_ ->
            div [ class "notification is-success" ]
                [ button [ class "delete", onClick CloseNotification ] []
                , text error_
                ]
