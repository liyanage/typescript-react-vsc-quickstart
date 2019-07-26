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
            <div className="card">
                <div className="card-body">
                    <h5 className="card-title">{this.props.title}</h5>
                    <p className="card-text">{this.props.children}</p>
                    <a href="#" className="btn btn-primary">Go somewhere</a>
                </div>
            </div>
        );
    }
}
