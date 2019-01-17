import React from 'react';
import Enzyme, { mount, shallow }  from 'enzyme';
import Adapter from 'enzyme-adapter-react-16';
import GameView from 'components/GameView.js';
import MessageView from 'components/MessageView.js';

Enzyme.configure({ adapter: new Adapter()})

describe('MessageView', () => {
  let wrapper, mountView

  beforeEach(() => {
    mountView = () => mount(
      <MessageView currentPlayer={'Player 1'} currentUser={'Player 2'} />
    )
  })

  describe("shows a message telling whose turn it is", () => {

    it('it tells you the name of the current player', () => {
      wrapper = mountView()
      expect(wrapper.find('.game__message--box').text()).toEqual('It is Player 1\'s turn.')
    })
  })
})
