import React, { Component } from 'react';
import PropTypes from 'prop-types';
import "../models/PlayingCard.js"



export default class WinnerView extends Component {
  static propTypes = {
    game: PropTypes.object.isRequired,
  }

  constructor(props) {
    super(props)
  }

  render() {
    return (
      <div className="winner-name game__message--box">{this.props.winner.name} WON THE GAME!</div>
    )
  }
}
