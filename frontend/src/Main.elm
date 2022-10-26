module Main exposing (main)

import Browser exposing (Document)
import Browser.Navigation as Nav
import Html exposing (a, footer, h1, header, main_, nav, text)
import Html.Attributes exposing (class, href)
import Url


type alias Model =
    { key : Nav.Key
    , url : Url.Url
    }


type Msg
    = NoOp
    | UrlRequested Browser.UrlRequest
    | UrlChanged Url.Url


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


init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init () url key =
    ( { key = key, url = url }, Cmd.none )


view : Model -> Document Msg
view model =
    { title = "Blog"
    , body =
        [ header [ class "bg-blue-900 h-20" ]
            [ nav [ class "flex justify-center items-center h-20" ]
                [ a [ class "decoration-none text-white hover:text-gray-100 text-5xl", href "/blog" ] [ text "Blog" ]
                ]
            ]
        , main_ [ class "flex flex-col bg-blue-900" ]
            [ h1 [] [ text "Blogs" ]
            ]
        , footer [] []
        ]
    }


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
