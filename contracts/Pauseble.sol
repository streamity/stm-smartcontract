pragma solidity ^0.4.18;

import "./TokenERC20.sol";

contract Pauseble is TokenERC20
{
    event EPause();
    event EUnpause();

    bool public paused = true;
    uint public startIcoDate = 0;

    modifier whenNotPaused()
    {
        require(!paused);
        _;
    }

    modifier whenPaused()
    {
        require(paused);
        _;
    }

    function pause() public onlyOwner
    {
        paused = true;
        EPause();
    }

    function pauseInternal() internal
    {
        paused = true;
        EPause();
    }

    function unpause() public onlyOwner
    {
        paused = false;
        EUnpause();
    }

    function unpauseInternal() internal
    {
        paused = false;
        EUnpause();
    }
}
