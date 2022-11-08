module Layout exposing (Details, view)

import Browser exposing (Document)
import Html exposing (Attribute, Html, button, div, footer, header, input, p, span, text)
import Html.Attributes exposing (class, style)
import Html.Events exposing (onClick)
import Material.Icons as Filled
import Material.Icons.Outlined as Outlined
import Material.Icons.Types exposing (Coloring(..))


type alias Details msg =
    { title : String
    , child : Html msg
    }


view : (a -> msg) -> Details a -> Browser.Document msg
view toMsg details =
    { title =
        details.title
    , body =
        [ viewHeader
        , Html.map toMsg <|
            details.child
        , viewFooter
        ]
    }


viewHeader : Html msg
viewHeader =
    header [ class "navbar flex justify-between bg-dark-100" ]
        [ button [ class "btn" ]
            [ Filled.arrow_back 25 Inherit
            ]
        , div [ class "flex-none gap-2" ]
            [ div [ class "form-control" ]
                [ input [ class "input input-bordered input-secondary" ] []
                ]
            ]
        ]


viewFooter : Html msg
viewFooter =
    footer [ class "footer items-center justify-between px-2" ]
        [ p [] [ text "dhzdhd's Blog" ]
        , div [ class "grid-flow-col gap-4" ]
            [ Filled.code 25 Inherit ]
        ]
