module Layout exposing (Details, view)

import Browser
import Html exposing (Html, button, div, footer, header, input, main_, p, text)
import Html.Attributes exposing (class)
import Material.Icons as Filled
import Material.Icons.Types exposing (Coloring(..))
import Octicons exposing (color, defaultOptions)


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
        , main_ [ class "h-full w-full max-w-[50rem] flex items-center justify-center" ]
            [ Html.map toMsg <|
                details.child
            ]
        , viewFooter
        ]
    }


viewHeader : Html msg
viewHeader =
    header [ class "navbar max-w-[50rem] flex justify-between bg-dark-100" ]
        [ button [ class "btn" ]
            [ Filled.arrow_back 25 Inherit
            ]
        , div [ class "flex-none gap-2" ]
            [ div [ class "form-control" ]
                [ input [ class "input input-bordered input-base-100" ] []
                ]
            ]
        ]


viewFooter : Html msg
viewFooter =
    footer [ class "footer max-w-[50rem] flex items-center justify-between px-2" ]
        [ p [] [ text "dhzdhd's Blog" ]
        , div [ class "flex gap-4" ]
            [ Octicons.markGithub (defaultOptions |> color "white") ]
        ]
