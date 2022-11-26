module Pages.Home_ exposing (view)

import Browser exposing (Document)
import Html
import Html.Attributes exposing (class)


view : Document msg
view =
    { title = "Homepage"
    , body = [ Html.span [ class "text-3xl bg-red-600" ] [ Html.text "Hello" ] ]
    }
