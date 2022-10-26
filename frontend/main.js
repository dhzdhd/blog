import "./styles.css";
import { Elm } from "./src/Main.elm";
import 'uno.css';

const root = document.getElementById("app");
const app = Elm.Main.init({
    node: root,
});
