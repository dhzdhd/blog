module Layout exposing (Details, view)

import Browser exposing (Document)
import Html exposing (Attribute, Html, div, footer, header)
import Html.Attributes exposing (class, style)


type alias Details msg =
    { title : String
    , child : Html msg
    }


view : (a -> msg) -> Details a -> Browser.Document msg
view toMsg details =
    { title =
        details.title
    , body =
        [ Html.map toMsg <|
            div [ class "center" ] [ details.child ]
        , viewFooter
        ]
    }


viewHeader : Html msg
viewHeader =
    header [] []


viewFooter : Html msg
viewFooter =
    footer [] []
