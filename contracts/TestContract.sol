// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

import "./CommitReveal.sol";

contract CommitRevealTest {
  CommitReveal public commitReveal = new CommitReveal();

  function commit(bytes32 dataHash) public {
    commitReveal.commit(commitReveal.getHash(dataHash));
  }

  function reveal(bytes32 revealHash) public {
    commitReveal.reveal(revealHash);
    (, , bool revealed) = commitReveal.commits(msg.sender);
    require(revealed, "CommitRevealTest::reveal: Not revealed");
  }
}
