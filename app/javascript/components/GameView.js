/*global fetch window*/
const fetch = require("node-fetch");
import React, { Component } from 'react';
import PropTypes from 'prop-types';
import CardView from "./CardView.js"
import MessageView from "./MessageView.js"
import PlayingCard from "../models/PlayingCard.js"
import { selectRank, selectPlayer, Game } from "../models/Game.js"
import Pusher from 'pusher-js'

export default class GameView extends Component {
  static propTypes = {
    game: PropTypes.object.isRequired,
  }

  constructor(props) {
    super(props)
    this.state = {
      game: this.props.game,
      requestedPlayer: null,
      requestedRank: null
    }

    Pusher.logToConsole = true;
    var pusher = new Pusher('03a04c4a34a3b4645a8b', {
      cluster: 'us2',
      forceTLS: true
    });

    var channel = pusher.subscribe("go_fish}");
    channel.bind('reload', function(data) {
      window.location.reload();
    });

    var channel = pusher.subscribe('go_fish');
    channel.bind('updateGame', (data) => {
      // debugger;
      if (window.location.pathname == `/games/${data.gameId}`) {
        console.log(data)
        this.fetchGame(data.gameId);
      }
    });
  }

  fetchGame(gameId) {
    // debugger;
    fetch(`/games/${gameId}`, {
      method: 'GET',
      headers:{ 'Content-Type': 'application/json', 'Accept': 'application/json' }
    })
    .then(res => res.json( ))
    .then((result) => {
        console.log("Result:", result)
        this.setState(() => ({ game: result }));
      }, (error) => {
    });
  }

  // fetchOptions(method, body) {
  //   const options = {
  //     method,
  //     headers:{'Content-Type': 'application/json', 'Accepts': 'application/json'}
  //   }
  //   if (body) {
  //     return Object.assign({}, options, {body: JSON.stringify(body)});
  //   }
  //   return options;
  // }
//   {
//     method: 'PATCH',
//     body: JSON.stringify({selectedOpponentName, rank: selectedCard.rank()})
//     headers:{'Content-Type': 'application/json', 'Accept': 'application/json'}
//   }
//   {
//   method: 'GET',
//   headers:{'Content-Type': 'application/json', 'Accept': 'application/json'}
// }
  handleRequestedPlayer(name) {
    if (this.state.game.current_user.name == this.state.game.current_player_name) {
      this.setState(() => {
        return { requestedPlayer: name }
      }, () => { this.playRoundIfPossible() });
    }
  }

  handleRequestedRank(rank) {
    if (this.state.game.current_user.name == this.state.game.current_player_name) {
      this.setState(() => {
        return { requestedRank: rank }
      }, () => { this.playRoundIfPossible() });
    }
  }

  playRoundIfPossible() {
    const { requestedPlayer, requestedRank } = this.state;
    const { gameId } = this.state.game;
    if (requestedPlayer && requestedRank) {
      fetch(`/games/${gameId}`, {
        method: 'PATCH',
        body: JSON.stringify({requestedPlayer, requestedRank}),
        headers:{ 'Content-Type': 'application/json', 'Accept': 'application/json' }
      })
      .then(res => res.json( ))
      .then(
        (result) => {
          this.setState(() => ({ game: result, requestedPlayer: null, requestedRank: null }));
        },
        (error) => {
        }
      )
    }
  }

  renderHeader() {
    return (
      <div>
        <h1>Welcome to Go Fish!</h1>
      </div>
    )
  }

  renderPlayer() {
    const player = this.state.game.current_user;
    return (
      <React.Fragment key={`player-${player.name}`}>
        <div className="flex_row settings__container">
          <div className="avatar_container avatar_image">
            <div className="avatar_name">{player.name}</div>
            <div className="avatar_sets">Sets:{player.sets}</div>
          </div>
          <div className="flex_row ">{this.renderHand(player)}</div>
        </div>
      </React.Fragment>
    )
  }

  renderOpponents() {
    const opponents = this.state.game.opponents;
    return opponents.map((opponent) => {
      return (
        <React.Fragment key={`player-${opponent.name}`}>
          <div className="opponent_avatar_container avatar_image clickable" value={opponent.name} onClick={() => {this.handleRequestedPlayer(opponent.name)}}>
            <div className="avatar_name">{opponent.name}</div>
            <div className="avatar_sets">Sets:{opponent.sets}</div>
          </div>
          <div>Cards: {opponent.hand}</div>
        </React.Fragment>
      )
    })
  }

  renderHand(player) {
    return player.hand.map((card) => {
      return (
        <React.Fragment key={`card-${card.rank}${card.suit}`}>
          <div className="clickable player_hand" id={`${card.rank}${card.suit}`} value={card.rank} onClick={() => {this.handleRequestedRank(card.rank)}}>
            <CardView card={card} />
          </div>
        </React.Fragment>
      )
    })
  }

  renderDeck() {
    const deck = this.state.game.gameDeck;
    return (
      <React.Fragment key={`deck-${this.state.game.id}`}>
        <div className="card_div-deck">
          <div className="card_div-text">{deck}</div>
        </div>
      </React.Fragment>
    )
  }

  render() {
    if (this.state.game.gameWinner) {
      return (
        <React.Fragment>
          <WinnerView winner={this.state.game.winner}/>
        </React.Fragment>
      )
    } else {
      return (
        <React.Fragment>
          <div className="container flex_column">
            {this.renderHeader()}
            {this.renderOpponents()}
            {this.renderDeck()}
            <MessageView currentPlayer={this.state.game.current_player_name} currentUser={this.state.game.current_user.name} />
            {this.renderPlayer()}
          </div>
        </React.Fragment>
      );
    }
  }
}
