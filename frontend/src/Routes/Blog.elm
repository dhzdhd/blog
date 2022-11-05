module Routes.Blog exposing (..)

import Browser exposing (Document)
import Browser.Navigation as Nav
import Html exposing (Html, a, footer, h1, header, main_, nav, text)
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
    h1 [] [ text "Blog" ]
