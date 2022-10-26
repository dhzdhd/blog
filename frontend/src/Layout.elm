module Layout exposing (view)

import Browser exposing (Document)
import Html exposing (Html, footer, header)


type Msg
    = NoOp


type alias Model =
    ()


view : Model -> Html Msg -> Document Msg
view model child =
    { title = ""
    , body =
        [ viewHeader
        , child
        , viewFooter
        ]
    }


viewHeader : Html Msg
viewHeader =
    header [] []


viewFooter : Html Msg
viewFooter =
    footer [] []
