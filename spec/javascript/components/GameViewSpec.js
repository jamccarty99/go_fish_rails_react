import React from 'react';
import Enzyme, { mount }  from 'enzyme';
import Adapter from 'enzyme-adapter-react-16';
import GameView from 'components/GameView.js';

Enzyme.configure({ adapter: new Adapter()})

const handleRequestedRank = jest.fn()
describe('GameView', () => {
  let wrapper, mountView
  const gameHash = {
    current_user:{name: 'Player 1', sets: 2, hand: [{rank:'Ace', suit:'Spades'}, {rank:'4', suit:'Clubs'}]},
    opponents:[{ name: 'Player 2', sets: 1, hand: 3 }],
    gameDeck: 38,
    round: 2,
    current_player_name: 'Player 1',
    gameId: 9
  }
  mountView = () => mount( <GameView game={gameHash} /> )

  it('renders without errors', () => {
    expect(mountView).not.toThrow()
  })

  describe("allows an initial request from current player", () => {
    beforeEach(() => {
      wrapper = mountView()
    });

    it('lets current player click a card and player to ask for from', () => {

      wrapper.find('.opponent_avatar_container').simulate('click');
      expect(wrapper.state().requestedPlayer).toEqual('Player 2')
      wrapper.find('#AceSpades').simulate('click');
      expect(wrapper.state().requestedRank).toEqual('Ace')
    })
  })
})
