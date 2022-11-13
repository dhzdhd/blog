module Layout exposing (Details, view)

import Browser
import Html exposing (Attribute, Html, a, button, div, footer, header, input, main_, p, text)
import Html.Attributes exposing (class, classList, disabled, href, target)
import Material.Icons as Filled
import Material.Icons.Types exposing (Coloring(..))
import Octicons exposing (color, defaultOptions)
import Url
import Url.Builder


type alias Details msg =
    { title : String
    , child : Html msg
    }


view : (a -> msg) -> Url.Url -> Details a -> Browser.Document msg
view toMsg url details =
    { title =
        details.title
    , body =
        [ viewHeader url
        , main_ [ class "h-full w-full py-16 max-w-[50rem] flex items-center justify-center" ]
            [ Html.map toMsg <|
                details.child
            ]
        , viewFooter
        ]
    }


viewHeader : Url.Url -> Html msg
viewHeader url =
    header [ class "navbar fixed top-0 pt-4 max-w-[50rem] flex justify-between z-10" ]
        [ a [ href (Url.Builder.relative [ "/" ] []) ]
            [ button
                [ class "btn bg-accent text-white"

                -- , disabled (url.path == "/")
                ]
                [ Filled.arrow_back 25 Inherit ]
            ]
        , div [ class "flex-none gap-2" ]
            [ div [ class "form-control" ]
                [ input [ class "input input-bordered input-base-100" ] []
                ]
            ]
        ]


viewFooter : Html msg
viewFooter =
    footer [ class "footer fixed bottom-0 pb-4 max-w-[50rem] flex items-center justify-between px-2 bg-base-100" ]
        [ p [] [ text "dhzdhd's Blog" ]
        , div [ class "flex gap-4 hover:-translate-y-1 duration-300" ]
            [ a
                [ href (Url.Builder
                .crossOrigin "https://github.com/dhzdhd/blog" [] [])
                , target "blank_"
                ]
                [ Octicons.markGithub (defaultOptions |> color "white") ]
            ]
        ]
