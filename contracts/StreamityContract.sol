pragma solidity ^0.4.18;

import "./ERC20Extending.sol";
import "./StreamityCrowdsale.sol";

contract StreamityContract is ERC20Extending, StreamityCrowdsale
{
    using SafeMath for uint;

    uint public weisRaised;  // how many weis was raised on crowdsale

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
            sell(msg.sender, msg.value);
            weisRaised = weisRaised.add(msg.value);
            if (now >= ICO.endDate) {
                pauseInternal();
                CrowdSaleFinished(crowdSaleStatus());
            }
        } else {
            revert();
        }
    }
}
