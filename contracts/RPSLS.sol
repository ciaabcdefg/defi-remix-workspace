
// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "contracts/CommitReveal.sol";

contract RPSLS {
    enum Move {
        ROCK,
        PAPER,
        SCISSORS,
        LIZARD,
        SPOCK
    }

    enum MoveResult {
        WIN,
        LOSE,
        TIE
    }

    uint public numPlayer = 0;
    uint public reward = 0;
    
    mapping (address => Move) public player_choice;
    CommitReveal public commitReveal = new CommitReveal();

    mapping(address => bool) public player_not_played;
    address[] public players;

    mapping(address => bool) private allowed_players;

    constructor() {
        allowed_players[0x5B38Da6a701c568545dCfcB03FcB875f56beddC4] = true;
        allowed_players[0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2] = true;
        allowed_players[0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db] = true;
        allowed_players[0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB] = true;
    }

    uint public numInput = 0;

    function addPlayer() public payable {
        require(numPlayer < 2);
        if (numPlayer > 0) {
            require(msg.sender != players[0]);
        }
        require(allowed_players[msg.sender] == true);
        require(msg.value == 1 ether);
        reward += msg.value;
        player_not_played[msg.sender] = true;
        players.push(msg.sender);
        numPlayer++;
    }

    // function input(Move choice) public  {
    //     require(numPlayer == 2);
    //     require(player_not_played[msg.sender]);
    //     // require(choice == 0 || choice == 1 || choice == 2);
    //     require(choice == Move.PAPER || choice == Move.ROCK || choice == Move.SCISSORS || choice == Move.LIZARD || choice == Move.SPOCK);
    //     player_choice[msg.sender] = choice;
    //     player_not_played[msg.sender] = false;
    //     numInput++;
    //     if (numInput == 2) {
    //         _checkWinnerAndPay();
    //     }
    // }

    function input(bytes32 dataHash) public {
        require(numPlayer == 2);
        require(player_not_played[msg.sender]);

        // require(choice == Move.PAPER || choice == Move.ROCK || choice == Move.SCISSORS || choice == Move.LIZARD || choice == Move.SPOCK);
        // player_choice[msg.sender] = choice;

        commitReveal.commit(dataHash);
        player_not_played[msg.sender] = false;
        numInput++;
        
        // if (numInput == 2) {
        //     _checkWinnerAndPay();
        // }
    }

    function revealChoice(bytes32 revealHash) public {
        commitReveal.reveal(revealHash);
        
    }

    function _getMoveResult(Move move_a, Move move_b) private pure returns(MoveResult) {
        if (move_a == move_b) {
            return MoveResult.TIE;
        }
        if (move_a == Move.ROCK && (move_b == Move.SCISSORS || move_b == Move.LIZARD)) {
            return MoveResult.WIN;
        }
        if (move_a == Move.PAPER && (move_b == Move.ROCK || move_b == Move.SPOCK)) {
            return MoveResult.WIN;
        }
        if (move_a == Move.SCISSORS && (move_b == Move.PAPER || move_b == Move.LIZARD)) {
            return MoveResult.WIN;
        }
        if (move_a == Move.LIZARD && (move_b == Move.SPOCK || move_b == Move.PAPER)) {
            return MoveResult.WIN;
        }
        if (move_a == Move.SPOCK && (move_b == Move.SCISSORS || move_b == Move.ROCK)) {
            return MoveResult.WIN;
        } 
        return MoveResult.LOSE;
    }

    function _checkWinnerAndPay() private {
        Move p0Choice = player_choice[players[0]];
        Move p1Choice = player_choice[players[1]];

        address payable account0 = payable(players[0]);
        address payable account1 = payable(players[1]);

        MoveResult result = _getMoveResult(p0Choice, p1Choice);

        if (result == MoveResult.WIN) {
            account0.transfer(reward);
        } else if (result == MoveResult.LOSE) {
            account1.transfer(reward);
        } else {
            account0.transfer(reward / 2);
            account1.transfer(reward / 2);
        }
    }
}