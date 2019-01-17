import React, { Component } from 'react';
import PropTypes from 'prop-types';
import "../models/PlayingCard.js"

export default class CardView extends Component {
  static propTypes = {
    card: PropTypes.object.isRequired,
  }

  constructor(props) {
    super(props)
    this.state = {}
  }
  render() {
    const rank = this.props.card.rank[0]
    const suit = this.props.card.suit[0]
    const cardAbr = (suit.toLowerCase() + rank.toLowerCase()).toString()
    return(
      <React.Fragment>
        <div className={`${cardAbr} container flex_column`}></div>
      </React.Fragment>
    );
  }
}
