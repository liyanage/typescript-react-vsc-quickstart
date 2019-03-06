import * as React from "react";
import * as ReactDOM from "react-dom";
import { Message } from "./components/Message";

const tf = (
    <Message title="Hi">
        <p>Hello World</p>
    </Message>
)
ReactDOM.render(tf, document.querySelector("#container"));
