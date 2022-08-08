use ybc::NavbarFixed::Top;
use ybc::TileCtx::{Ancestor, Child, Parent};
use ybc::TileSize::Four;
use yew::prelude::*;

pub struct Footer();

impl Component for Footer {
    type Message = ();
    type Properties = ();

    fn create(_: &Context<Self>) -> Self {
        Self()
    }

    fn view(&self, _: &Context<Self>) -> Html {
        html! {
          <ybc::Footer classes={classes!("has-background-dark")}>
            <ybc::Content>
                {"byeeeee"}
            </ybc::Content>
          </ybc::Footer>
        }
    }
}
