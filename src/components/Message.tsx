import * as React from "react";

interface MessageProps {
    title: string;
}

export class Message extends React.Component<MessageProps> {
    constructor(props: MessageProps) {
        super(props);
    }
    render() {
        return (
            <div className="ui info message">
                <div className="header">{this.props.title}</div>
                <div>{this.props.children}</div>
            </div>
        );
    }
}
