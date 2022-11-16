module Routes.Blog exposing (..)

import Browser
import Browser.Navigation as Nav
import Html exposing (Html, text)
import Html.Attributes as Attr
import Http
import Markdown.Block as Block
import Markdown.Html
import Markdown.Parser
import Markdown.Renderer
import Routes.Home exposing (BlogPost, RequestState(..), blogPostDecoder)
import Url
import Url.Parser exposing (Parser)


type alias Model =
    { key : Nav.Key
    , url : Url.Url
    , slug : String
    , post : RequestState BlogPost Http.Error
    }


type Msg
    = NoOp
    | UrlRequested Browser.UrlRequest
    | UrlChanged Url.Url
    | GotBlogPost (Result Http.Error BlogPost)


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

        GotBlogPost result ->
            case result of
                Ok post ->
                    ( { model | post = Success post }, Cmd.none )

                Err err ->
                    ( { model | post = Failure err }, Cmd.none )


init : String -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init slug url key =
    ( { key = key, url = url, slug = slug, post = Loading }, getBlogPost slug )


deadEndsToString deadEnds =
    -- ! Add annotation
    deadEnds
        |> List.map Markdown.Parser.deadEndToString
        |> String.join "\n"


view : Model -> Html Msg
view model =
    case model.post of
        Success post ->
            let
                md =
                    post.content
                        |> Markdown.Parser.parse
                        |> Result.mapError deadEndsToString
                        |> Result.andThen (\ast -> Markdown.Renderer.render htmlRenderer ast)
            in
            Html.div [ Attr.class "flex flex-col gap-5 w-full h-full px-2 py-7" ]
                [ Html.h1 [ Attr.class "text-5xl font-bold" ] [ text (post.title |> String.toUpper) ]
                , Html.div [ Attr.class "flex justify-between" ]
                    [ Html.span [] [ text post.createdAt ]
                    , Html.span [ Attr.class "badge badge-outline justify-end" ] [ text "Tech" ]
                    ]
                , Html.hr [ Attr.class "bg-accent border-none h-[1px]" ] []
                , Html.div []
                    (case md of
                        Ok html ->
                            html

                        Err str ->
                            [ text str ]
                    )
                ]

        Loading ->
            Html.h1 [ Attr.class "text-2xl" ] [ Html.text "Loading" ]

        Failure err ->
            Html.h1 [ Attr.class "text-2xl" ]
                [ Html.text
                    (case err of
                        Http.BadUrl str ->
                            str

                        Http.BadStatus resp ->
                            "Status " ++ String.fromInt resp

                        Http.BadBody str ->
                            str

                        Http.NetworkError ->
                            "Network Error"

                        _ ->
                            "Error!"
                    )
                ]


getBlogPost : String -> Cmd Msg
getBlogPost slug =
    Http.get
        { url = "http://127.0.0.1:8000/api/v1/articles/" ++ slug
        , expect = Http.expectJson GotBlogPost blogPostDecoder
        }


htmlRenderer : Markdown.Renderer.Renderer (Html msg)
htmlRenderer =
    { heading =
        \{ level, children } ->
            case level of
                Block.H1 ->
                    Html.h1 [ Attr.class "text-3xl" ] children

                Block.H2 ->
                    Html.h2 [ Attr.class "text-2xl" ] children

                Block.H3 ->
                    Html.h3 [ Attr.class "text-xl" ] children

                Block.H4 ->
                    Html.h4 [ Attr.class "text-3xl" ] children

                Block.H5 ->
                    Html.h5 [ Attr.class "text-2xl" ] children

                Block.H6 ->
                    Html.h6 [ Attr.class "text-xl" ] children
    , paragraph = Html.p []
    , hardLineBreak = Html.br [] []
    , blockQuote = Html.blockquote []
    , strong =
        \children -> Html.strong [] children
    , emphasis =
        \children -> Html.em [] children
    , codeSpan =
        \content -> Html.code [] [ Html.text content ]
    , link =
        \link content ->
            case link.title of
                Just title ->
                    Html.a
                        [ Attr.href link.destination
                        , Attr.title title
                        ]
                        content

                Nothing ->
                    Html.a [ Attr.href link.destination ] content
    , image =
        \imageInfo ->
            case imageInfo.title of
                Just title ->
                    Html.img
                        [ Attr.src imageInfo.src
                        , Attr.alt imageInfo.alt
                        , Attr.title title
                        ]
                        []

                Nothing ->
                    Html.img
                        [ Attr.src imageInfo.src
                        , Attr.alt imageInfo.alt
                        ]
                        []
    , text =
        Html.text
    , unorderedList =
        \items ->
            Html.ul []
                (items
                    |> List.map
                        (\item ->
                            case item of
                                Block.ListItem task children ->
                                    let
                                        checkbox =
                                            case task of
                                                Block.NoTask ->
                                                    Html.text ""

                                                Block.IncompleteTask ->
                                                    Html.input
                                                        [ Attr.disabled True
                                                        , Attr.checked False
                                                        , Attr.type_ "checkbox"
                                                        ]
                                                        []

                                                Block.CompletedTask ->
                                                    Html.input
                                                        [ Attr.disabled True
                                                        , Attr.checked True
                                                        , Attr.type_ "checkbox"
                                                        ]
                                                        []
                                    in
                                    Html.li [] (checkbox :: children)
                        )
                )
    , orderedList =
        \startingIndex items ->
            Html.ol
                (case startingIndex of
                    1 ->
                        [ Attr.start startingIndex ]

                    _ ->
                        []
                )
                (items
                    |> List.map
                        (\itemBlocks ->
                            Html.li []
                                itemBlocks
                        )
                )
    , html = Markdown.Html.oneOf []
    , codeBlock =
        \block ->
            Html.pre []
                [ Html.code []
                    [ Html.text block.body
                    ]
                ]
    , thematicBreak = Html.hr [] []
    , table = Html.table []
    , tableHeader = Html.thead []
    , tableBody = Html.tbody []
    , tableRow = Html.tr []
    , tableHeaderCell =
        \maybeAlignment ->
            let
                attrs =
                    maybeAlignment
                        |> Maybe.map
                            (\alignment ->
                                case alignment of
                                    Block.AlignLeft ->
                                        "left"

                                    Block.AlignCenter ->
                                        "center"

                                    Block.AlignRight ->
                                        "right"
                            )
                        |> Maybe.map Attr.align
                        |> Maybe.map List.singleton
                        |> Maybe.withDefault []
            in
            Html.th attrs
    , tableCell = \_ children -> Html.td [] children
    , strikethrough = Html.span [ Attr.style "text-decoration-line" "line-through" ]
    }
