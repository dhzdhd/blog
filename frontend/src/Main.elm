module Main exposing (main)

import Browser exposing (Document)
import Browser.Dom exposing (Error(..))
import Browser.Navigation as Nav
import Html exposing (a, div, footer, h1, header, main_, nav, text)
import Html.Attributes exposing (class, href)
import Layout
import Routes.Blog as Blog
import Routes.Home as Home
import Url
import Url.Parser as Parser exposing ((</>), Parser, custom, fragment, map, oneOf, s, string, top)


type Page
    = NotFoundPage
    | HomePage Home.Model
    | BlogPage Blog.Model


type alias Model =
    { key : Nav.Key
    , url : Url.Url
    , page : Page
    }


type Msg
    = NoOp
    | UrlRequested Browser.UrlRequest
    | UrlChanged Url.Url
    | HomeMsg Home.Msg
    | BlogMsg Blog.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
    case message of
        NoOp ->
            ( model, Cmd.none )

        UrlRequested urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( model, Nav.pushUrl model.key (Url.toString url) )

                Browser.External href ->
                    ( model, Nav.load href )

        UrlChanged url ->
            stepUrl url model

        HomeMsg homeMsg ->
            case model.page of
                HomePage homeModel ->
                    stepHome model (Home.update homeMsg homeModel)

                _ ->
                    ( model, Cmd.none )

        BlogMsg blogMsg ->
            case model.page of
                BlogPage blogModel ->
                    stepBlog model (Blog.update blogMsg blogModel)

                _ ->
                    ( model, Cmd.none )


init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init _ url key =
    stepUrl url
        { key = key
        , url = url
        , page = NotFoundPage
        }


view : Model -> Browser.Document Msg
view model =
    case model.page of
        NotFoundPage ->
            Layout.view never
                model.url
                { title = "Not Found"
                , child = h1 [ class "text-2xl" ] [ text "404 Not Found" ]
                }

        HomePage homeModel ->
            Layout.view HomeMsg model.url { title = "Blog", child = Home.view homeModel }

        BlogPage blogModel ->
            Layout.view BlogMsg model.url { title = "Blog", child = Blog.view blogModel }


main : Program () Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        , onUrlRequest = UrlRequested
        , onUrlChange = UrlChanged
        }


stepHome : Model -> ( Home.Model, Cmd Home.Msg ) -> ( Model, Cmd Msg )
stepHome model ( homeModel, cmds ) =
    ( { model | page = HomePage homeModel }
    , Cmd.map HomeMsg cmds
    )


stepBlog : Model -> ( Blog.Model, Cmd Blog.Msg ) -> ( Model, Cmd Msg )
stepBlog model ( blogModel, cmds ) =
    ( { model | page = BlogPage blogModel }
    , Cmd.map BlogMsg cmds
    )


stepUrl : Url.Url -> Model -> ( Model, Cmd Msg )
stepUrl url model =
    let
        parser =
            oneOf
                [ map
                    (stepHome { model | url = url } (Home.init model.url model.key))
                    top
                , map
                    (\slug -> stepBlog { model | url = url } (Blog.init slug model.url model.key))
                    (s "blog" </> string)
                ]
    in
    case Parser.parse parser url of
        Just answer ->
            answer

        Nothing ->
            ( { model | page = NotFoundPage }
            , Cmd.none
            )
