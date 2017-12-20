pragma solidity ^0.4.18;

import "./SafeMath.sol";
import "./Pauseble.sol";

contract StreamityCrowdsale is Pauseble
{
    using SafeMath for uint;

    uint public stage = 0;

    event CrowdSaleFinished(string info);

    struct Ico {
        uint256 tokens;             // Tokens in crowdsale
        uint startDate;             // Date when crowsale will be starting, after its starting that property will be the 0
        uint endDate;               // Date when crowdsale will be stop
        uint8 discount;             // Discount
        uint8 discountFirstDayICO;  // Discount. Only for first stage ico
    }

    Ico public ICO;

    /**
    * Expanding of the functionality
    *
    * @param _numerator - Numerator - value (10000)
    * @param _denominator - Denominator - value (10000)
    *
    * example: price 1000 tokens by 1 ether = changeRate(1, 1000)
    */
    function changeRate(uint256 _numerator, uint256 _denominator) public onlyOwner
        returns (bool success)
    {
        if (_numerator == 0) _numerator = 1;
        if (_denominator == 0) _denominator = 1;

        buyPrice = (_numerator.mul(DEC)).div(_denominator);

        return true;
    }

    /*
    * Function show in contract what is now
    *
    */
    function crowdSaleStatus() internal constant
        returns (string)
    {
        if (1 == stage) {
            return "Pre-ICO";
        } else if(2 == stage) {
            return "ICO first stage";
        } else if (3 == stage) {
            return "ICO second stage";
        } else if (4 >= stage) {
            return "feature stage";
        }

        return "there is no stage at present";
    }

    /*
    * Function for selling tokens in crowd time.
    *
    */
    function sell(address _investor, uint256 amount) internal
    {
        uint256 _amount = (amount.mul(DEC)).div(buyPrice);

        if (1 == stage) {
            _amount = _amount.add(withDiscount(_amount, ICO.discount));
        }
        else if (2 == stage)
        {
            if (now <= ICO.startDate + 1 days)
            {
                  if (0 == ICO.discountFirstDayICO) {
                      ICO.discountFirstDayICO = 20;
                  }

                  _amount = _amount.add(withDiscount(_amount, ICO.discountFirstDayICO));
            } else {
                _amount = _amount.add(withDiscount(_amount, ICO.discount));
            }
        } else if (3 == stage) {
            _amount = _amount.add(withDiscount(_amount, ICO.discount));
        }

        if (ICO.tokens < _amount)
        {
            CrowdSaleFinished(crowdSaleStatus());
            pauseInternal();

            revert();
        }

        ICO.tokens = ICO.tokens.sub(_amount);
        avaliableSupply = avaliableSupply.sub(_amount);

        _transfer(this, _investor, _amount);
    }

    /*
    * Function for start crowdsale (any)
    *
    * @param _tokens - How much tokens will have the crowdsale - amount humanlike value (10000)
    * @param _startDate - When crowdsale will be start - unix timestamp (1512231703 )
    * @param _endDate - When crowdsale will be end - humanlike value (7) same as 7 days
    * @param _discount - Discount for the crowd - humanlive value (7) same as 7 %
    * @param _discount - Discount for the crowds first day - humanlive value (7) same as 7 %
    */
    function startCrowd(uint256 _tokens, uint _startDate, uint _endDate, uint8 _discount, uint8 _discountFirstDayICO) public onlyOwner
    {
        require(_tokens * DEC <= avaliableSupply);  // require to set correct tokens value for crowd
        startIcoDate = _startDate;
        ICO = Ico (_tokens * DEC, _startDate, _startDate + _endDate * 1 days , _discount, _discountFirstDayICO);
        stage = stage.add(1);
        unpauseInternal();
    }

    /**
    * Function for web3js, should be call when somebody will buy tokens from website. This function only delegator.
    *
    * @param _investor - address of investor (who payed)
    * @param _amount - ethereum
    */
    function transferWeb3js(address _investor, uint256 _amount) external onlyOwner
    {
        sell(_investor, _amount);
    }

    /**
    * Function for adding discount
    *
    */
    function withDiscount(uint256 _amount, uint _percent) internal pure
        returns (uint256)
    {
        return (_amount.mul(_percent)).div(100);
    }
}
