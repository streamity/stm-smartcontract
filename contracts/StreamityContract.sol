pragma solidity ^0.4.18;

import "./ERC20Extending.sol";
import "./StreamityCrowdsale.sol";

contract StreamityContract is ERC20Extending, StreamityCrowdsale
{
    /* Streamity tokens Constructor */
    function StreamityContract() public TokenERC20(180000000, "Streamity", "STM") {} //change before send !!!

    /**
    * Function payments handler
    *
    */
    function () public payable
    {
        assert(msg.value >= 1 ether / 10);
        require(now >= ICO.startDate);

        if (paused == false) {
            paymentManager(msg.sender, msg.value);
        } else {
            revert();
        }
    }
}
