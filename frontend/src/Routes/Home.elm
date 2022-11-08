module Routes.Home exposing (..)

import Browser exposing (Document)
import Browser.Navigation as Nav
import Html exposing (Html, a, div, footer, h1, h2, header, main_, nav, p, text)
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


init : Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init url key =
    ( { key = key, url = url }, Cmd.none )


view : Model -> Html Msg
view model =
    main_ [ class "h-full flex flex-col p-2" ]
        [ h1 [] []
        , div [ class "grid-col-3 gap-5" ]
            [ viewCard model
            , viewCard model
            , viewCard model
            , viewCard model
            ]
        ]


viewCard : Model -> Html Msg
viewCard model =
    div [ class "card w-96 bg-neutral shadow-xl" ]
        [ div [ class "card-body" ]
            [ h2 [ class "card-title" ] [ text "Test" ]
            , p [] [ text "lorem ipsum" ]
            , div [ class "card-actions justify-end" ]
                [ div [ class "badge badge-outline" ] [ text "Tech" ]
                ]
            ]
        ]
