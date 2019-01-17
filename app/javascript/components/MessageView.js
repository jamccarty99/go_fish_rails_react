import React, { Component } from 'react';
import PropTypes from 'prop-types';

export default class MessageView extends Component {
  static propTypes = {
    currentPlayer: PropTypes.string.isRequired,
    currentUser: PropTypes.string.isRequired
  }

  constructor(props) {
    super(props)
    this.state = {}
  }

  render() {
    // debugger;
    if (this.props.currentPlayer == this.props.currentUser) {
      return( <div className="game__message--box">"It is your turn!"</div> )
    } else {
      return (<div className="game__message--box">It is {`${this.props.currentPlayer}`}'s turn.</div> )
    }
  }
}
