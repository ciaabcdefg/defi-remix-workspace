// SPDX-License-Identifier: GPL-3.0
        
pragma solidity >=0.4.22 <0.9.0;

// This import is automatically injected by Remix
import "remix_tests.sol"; 
// This import is required to use custom transaction context
// Although it may fail compilation in 'Solidity Compiler' plugin
// But it will work fine in 'Solidity Unit Testing' plugin
import "remix_accounts.sol";
import "../contracts/RPSLS.sol";

// File name has to end with '_test.sol', this file can contain more than one testSuite contracts
contract testSuite {
    RPSLS rpsls;
    
    
    /// 'beforeAll' runs before all other tests
    /// More special functions are: 'beforeEach', 'beforeAll', 'afterEach' & 'afterAll'
    function beforeAll() public {
        rpsls = new RPSLS();
    }

    function testAddPlayers() public {
        (bool success1,) = address(rpsls).call{value: 1 ether}(abi.encodeWithSignature("addPlayer()"));
        (bool success2,) = address(rpsls).call{value: 1 ether}(abi.encodeWithSignature("addPlayer()"));

        Assert.ok(success1, "Player 1 should be added successfully.");
        Assert.ok(success2, "Player 2 should be added successfully.");
        Assert.equal(rpsls.numPlayer(), 2, "There should be two players in the game.");
    }
}
    