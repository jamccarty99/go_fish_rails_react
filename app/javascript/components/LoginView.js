import React from 'react';
import PropTypes from 'prop-types';

export default class LoginView extends React.Component {

  static propTypes = {
    onLogin: PropTypes.func.isRequired
  }

  constructor(props) {
    super(props)
    this.state = { name: '', numberOfBots: '' }
  }

  onSubmit(e) {
    e.preventDefault();
    const numberOfBots = Number(e.target.numberOfBots.value)
    this.props.onLogin(e.target.name.value, numberOfBots)
  }

  nameInput() {
    return document.getElementById('name')
  }

  botInput() {
    return document.getElementById('numberOfBots')
  }

  submitButton() {
    return document.getElementById('submit')
  }

  render() {
    return (
      <form class="user-form">
        <label for="name">Name</label>
        <input type="text" id="name" />
        <label for="numberOfBots">Number of Bots</label>
        <input type="number" id="numberOfBots" value="1"/>

        <input id="submit" type="submit" value="Login"/>
      </form>
    )
  }
}
