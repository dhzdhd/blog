module Main exposing (..)

import Spa



-- ! Setup
-- main =
--     Spa.init
--         { defaultView = View.defaultView
--         , extractIdentity = Shared.identity
--         }
--         |> Spa.addPublicPage mappers Route.matchHome Home.page
--         |> Spa.addPublicPage mappers Route.matchAbout About.page
--         |> Spa.addPublicPage mappers Route.matchSignIn SignIn.page
--         |> Spa.addProtectedPage mappers Route.matchCounter Counter.page
--         |> Spa.addPublicPage mappers Route.matchTime Time.page
--         |> Spa.application View.map
--             { init = Shared.init
--             , subscriptions = Shared.subscriptions
--             , update = Shared.update
--             , toRoute = Route.toRoute
--             , toDocument = toDocument
--             , protectPage = Route.toUrl >> Just >> Route.SignIn >> Route.toUrl
--             }
--         |> Browser.application
