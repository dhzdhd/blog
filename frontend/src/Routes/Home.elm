module Routes.Home exposing (..)

import Browser
import Browser.Navigation as Nav
import Html exposing (Html, a, div, footer, h1, h2, header, main_, nav, p, text)
import Html.Attributes exposing (class, href)
import Http
import Json.Decode exposing (Decoder, field, list, map, map3, map4, string)
import Url
import Url.Builder


type Option a
    = Some a
    | None


type alias Model =
    { key : Nav.Key
    , url : Url.Url
    , posts : RequestState BlogPostList Http.Error
    }


type alias BlogPostList =
    { data : List BlogPost
    }


type alias BlogPost =
    { uid : String
    , title : String
    , content : String
    , createdAt : String
    }


type Msg
    = NoOp
    | UrlRequested Browser.UrlRequest
    | UrlChanged Url.Url
    | GotBlogPosts (Result Http.Error BlogPostList)


type RequestState a b
    = Failure b
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
                    ( { model | posts = Failure err }, Cmd.none )


init : Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init url key =
    ( { key = key, url = url, posts = Loading }, getAllBlogPosts )


view : Model -> Html Msg
view model =
    case model.posts of
        Success posts ->
            div [ class "h-full w-full flex flex-col px-2 py-5 gap-5" ]
                [ h1 [ class "text-2xl" ] [ text "All blogs" ]
                , div [ class "grid gap-5 items-center" ]
                    (case posts.data of
                        [] ->
                            [ div [ class "flex items-center justify-center h-100" ]
                                [ p [ class "text-2xl" ] [ text "No blogs posted yet!" ]
                                ]
                            ]

                        _ ->
                            List.map
                                (\data -> viewCard data)
                                posts.data
                    )
                ]

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


viewCard : BlogPost -> Html Msg
viewCard data =
    a [ href (Url.Builder.relative [ "blog", data.uid ] []) ]
        [ div [ class "card pointer w-full bg-secondary text-base-primary shadow-xl hover:scale-[102%] duration-300 z-0" ]
            [ div [ class "card-body" ]
                [ h2 [ class "card-title" ] [ text data.title ]
                , div [ class "card-actions justify-end" ]
                    [ p [] [ text data.createdAt ]
                    , div [ class "badge badge-outline justify-end" ] [ text "Tech" ]
                    ]
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
    map4 BlogPost
        (field "uid" string)
        (field "title" string)
        (field "content" string)
        (field "created_at" string)
