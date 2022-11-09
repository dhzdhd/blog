module Routes.Home exposing (..)

import Browser exposing (Document)
import Browser.Navigation as Nav
import Html exposing (Html, a, div, footer, h1, h2, header, main_, nav, p, text)
import Html.Attributes exposing (class, href)
import Http
import Json.Decode exposing (Decoder, field, list, map, map2, string)
import Json.Encode exposing (encode, object)
import List exposing (map3)
import Url exposing (Url)


type Option a
    = Some a
    | None


type alias Model =
    { key : Nav.Key
    , url : Url.Url
    , posts : RequestState BlogPostList
    , error : Option Http.Error
    }


type alias BlogPostList =
    { data : List BlogPost
    }


type alias BlogPost =
    { title : String
    , content : String
    }


type Msg
    = NoOp
    | UrlRequested Browser.UrlRequest
    | UrlChanged Url.Url
    | GotBlogPosts (Result Http.Error BlogPostList)


type RequestState a
    = Failure
    | Loading
    | Success a


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

        GotBlogPosts result ->
            case result of
                Ok posts ->
                    ( { model | posts = Success posts }, Cmd.none )

                Err err ->
                    ( { model | error = Some err, posts = Failure }, Cmd.none )


init : Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init url key =
    ( { key = key, url = url, posts = Loading, error = None }, getAllBlogPosts )


view : Model -> Html Msg
view model =
    case model.posts of
        Success posts ->
            div [ class "h-full w-full flex flex-col px-2 py-5 gap-5" ]
                [ h1 [ class "text-2xl" ] [ text "All blogs" ]
                , div [ class "grid gap-5" ]
                    [ viewCard model
                    , viewCard model
                    , viewCard model
                    , viewCard model
                    ]
                ]

        Loading ->
            h1 [ class "text-2xl" ] [ text "Loading" ]

        Failure ->
            case model.error of
                None ->
                    h1 [ class "text-2xl" ] [ text "" ]

                Some errr ->
                    h1 [ class "text-2xl" ]
                        [ text
                            (case errr of
                                Http.BadUrl a ->
                                    a

                                Http.BadStatus resp ->
                                    String.fromInt resp

                                Http.BadBody str ->
                                    str

                                Http.NetworkError ->
                                    "e"

                                _ ->
                                    "hi"
                            )
                        ]


viewCard : Model -> Html Msg
viewCard model =
    div [ class "card w-full bg-neutral shadow-xl hover:scale-[102%] duration-300" ]
        [ div [ class "card-body" ]
            [ h2 [ class "card-title" ] [ text "Test" ]
            , p [] [ text "lorem ipsum" ]
            , div [ class "card-actions justify-end" ]
                [ div [ class "badge badge-outline" ] [ text "Tech" ]
                ]
            ]
        ]


getAllBlogPosts : Cmd Msg
getAllBlogPosts =
    Http.get
        { url = "http://127.0.0.1:8000/api/v1/articles"
        , expect = Http.expectJson GotBlogPosts blogPostListDecoder
        }


blogPostListDecoder : Decoder BlogPostList
blogPostListDecoder =
    map BlogPostList
        (field "data" (list blogPostDecoder))


blogPostDecoder : Decoder BlogPost
blogPostDecoder =
    map2 BlogPost
        (field "title" string)
        (field "content" string)
