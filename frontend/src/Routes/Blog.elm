module Routes.Blog exposing (..)

import Browser exposing (Document)
import Browser.Navigation as Nav
import Html exposing (a, footer, h1, header, main_, nav, text)
import Html.Attributes exposing (class, href)
import Url


type alias BlogModel =
    { key : Nav.Key
    , url : Url.Url
    }


type Msg
    = NoOp
    | UrlRequested Browser.UrlRequest
    | UrlChanged Url.Url


update : Msg -> BlogModel -> ( BlogModel, Cmd Msg )
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


init : () -> Url.Url -> Nav.Key -> ( BlogModel, Cmd Msg )
init () url key =
    ( { key = key, url = url }, Cmd.none )


view : BlogModel -> Document Msg
view model =
    { title = "Blog"
    , body =
        [ header [ class "bg-blue-900 h-20" ]
            [ nav [ class "flex justify-center items-center h-20" ]
                [ a [ class "decoration-none text-white hover:text-gray-100 text-5xl", href "/home" ] [ text "Beeeeeeeeelog" ]
                ]
            ]
        , main_ [ class "flex flex-col bg-blue-900" ]
            [ h1 [] [ text "eeeeeeeeeeeeeee" ]
            ]
        , footer [] []
        ]
    }
