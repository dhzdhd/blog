module Routes.Blog exposing (..)

import Browser exposing (Document)
import Browser.Navigation as Nav
import Html exposing (Html, a, div, footer, h1, header, main_, nav, text)
import Html.Attributes exposing (class, href)
import Http
import Routes.Home exposing (BlogPost, RequestState(..), blogPostDecoder)
import Url


type alias Model =
    { key : Nav.Key
    , url : Url.Url
    , slug : String
    , post : RequestState BlogPost Http.Error
    }


type Msg
    = NoOp
    | UrlRequested Browser.UrlRequest
    | UrlChanged Url.Url
    | GotBlogPost (Result Http.Error BlogPost)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        UrlRequested urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( model, Nav.pushUrl model.key (Url.toString url) )

                Browser.External href ->
                    ( model, Nav.load href )

        UrlChanged url ->
            ( { model | url = url }
            , Cmd.none
            )

        GotBlogPost result ->
            case result of
                Ok post ->
                    ( { model | post = Success post }, Cmd.none )

                Err err ->
                    ( { model | post = Failure err }, Cmd.none )


init : String -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init slug url key =
    ( { key = key, url = url, slug = slug, post = Loading }, getBlogPost slug )


view : Model -> Html Msg
view model =
    case model.post of
        Success post ->
            div [ class "" ]
                [ text post.content ]

        Loading ->
            h1 [ class "text-2xl" ] [ text "Loading" ]

        Failure err ->
            h1 [ class "text-2xl" ]
                [ text
                    (case err of
                        Http.BadUrl str ->
                            str

                        Http.BadStatus resp ->
                            "Status " ++ String.fromInt resp

                        Http.BadBody str ->
                            str

                        Http.NetworkError ->
                            "Network Error"

                        _ ->
                            "Error!"
                    )
                ]


getBlogPost : String -> Cmd Msg
getBlogPost slug =
    Http.get
        { url = "http://127.0.0.1:8000/api/v1/articles/" ++ slug
        , expect = Http.expectJson GotBlogPost blogPostDecoder
        }
