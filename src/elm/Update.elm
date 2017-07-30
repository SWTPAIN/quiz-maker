module Update exposing (..)

import Model exposing (Msg(..), Model)
import Page.Home.Model as PageHomeModel
import Page.DoQuiz.Update as PageDoQuizUpdate
import Page.Home.Update as PageHomeUpdate
import Port
import Port.Utils
import Route exposing (..)
import Navigation
import List.Extra as List


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        MountRoute route ->
            mountRoute route model

        AddQuizResult result ->
            case result of
                Ok quiz ->
                    ( { model
                        | home = PageHomeModel.initialModel
                        , notification = Just "Your quiz is created"
                        , quizzes = quiz :: model.quizzes
                      }
                    , Cmd.none
                    )

                Err error ->
                    ( { model | notification = Just error }, Cmd.none )

        DoQuizMsg msg ->
            pageUpdate
                (\pageM model -> { model | doQuiz = pageM })
                DoQuizMsg
                (PageDoQuizUpdate.update
                    msg
                    model.doQuiz
                )
                model

        HomeMsg msg ->
            pageUpdate
                (\pageM model -> { model | home = pageM })
                HomeMsg
                (PageHomeUpdate.update
                    msg
                    model.home
                )
                model


pageUpdate : (model -> Model -> Model) -> (msg -> Msg) -> ( model, Cmd msg ) -> Model -> ( Model, Cmd Msg )
pageUpdate pageUpdater msgTagger ( pageModel, pageCmd ) model =
    ( pageUpdater pageModel model, Cmd.map msgTagger pageCmd )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Port.addQuizResult (Port.Utils.mapServerResult >> AddQuizResult)
        ]


init : Model.Flags -> Navigation.Location -> ( Model, Cmd Msg )
init flags location =
    mountRoute (Route.parser location) (Model.initialModel flags)


mountRoute : Route -> Model -> ( Model, Cmd Msg )
mountRoute newRoute model =
    case newRoute of
        DoQuiz quizId ->
            case List.find (\{ id } -> quizId == id) model.quizzes of
                Nothing ->
                    ( model, Cmd.none )

                Just quiz ->
                    let
                        ( newDoQuiz, cmd ) =
                            PageDoQuizUpdate.mount quiz model.doQuiz
                    in
                        ( { model
                            | route = newRoute
                            , doQuiz = newDoQuiz
                          }
                        , Cmd.map DoQuizMsg cmd
                        )

        _ ->
            ( { model
                | route = newRoute
              }
            , Cmd.none
            )
