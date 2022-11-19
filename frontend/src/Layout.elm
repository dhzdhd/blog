module Layout exposing (Details, view)

import Browser
import Html exposing (Html, a, button, div, footer, header, input, main_, p, text)
import Html.Attributes exposing (class, href, target)
import Html.Events exposing (onFocus, onInput)
import Material.Icons.Outlined as Outlined
import Material.Icons.Types exposing (Coloring(..))
import Octicons exposing (color, defaultOptions)
import Url
import Url.Builder


type alias Details msg =
    { title : String
    , child : Html msg
    }


view : (a -> msg) -> (String -> msg) -> Url.Url -> Details a -> Browser.Document msg
view toMsg msg url details =
    { title =
        details.title
    , body =
        [ viewHeader url msg
        , main_ [ class "h-full w-full py-16 max-w-[50rem] flex items-center justify-center" ]
            [ Html.map toMsg <|
                details.child
            ]
        , viewFooter
        ]
    }


viewHeader : Url.Url -> (String -> msg) -> Html msg
viewHeader url msg =
    header [ class "navbar fixed top-0 pt-4 max-w-[50rem] flex justify-between z-10" ]
        [ a [ href (Url.Builder.relative [ "/" ] []) ]
            [ button
                [ class "btn bg-accent text-white"

                -- , disabled (url.path == "/")
                ]
                [ Outlined.home 25 Inherit ]
            ]
        , div [ class "flex-none gap-2" ]
            [ div [ class "form-control" ]
                [ div [ class "input-group" ]
                    [ input
                        [ class "input input-bordered input-accent input-base-100"
                        , onInput (\s -> msg s)
                        ]
                        []
                    , button [ class "btn btn-square" ]
                        [ Octicons.search (defaultOptions |> color "white")
                        ]
                    ]
                ]
            ]
        ]


viewFooter : Html msg
viewFooter =
    footer [ class "footer fixed bottom-0 pb-4 max-w-[50rem] flex items-center justify-between px-2 bg-base-100" ]
        [ p [] [ text "dhzdhd's Blog" ]
        , div [ class "flex gap-4 hover:-translate-y-1 duration-300" ]
            [ a
                [ href (Url.Builder.crossOrigin "https://github.com/dhzdhd/blog" [] [])
                , target "blank_"
                ]
                [ Octicons.markGithub (defaultOptions |> color "white") ]
            ]
        ]
