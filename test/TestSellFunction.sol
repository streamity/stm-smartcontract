pragma solidity ^0.4.4;

/*
 *   sell() func. test for < uint256 _amount = (amount.mul(DEC)).div(buyPrice); >
 */
contract TestSellFunction {

    uint256 public DEC = 1 * 10 ** uint(18);
    uint256 public ETH = 1 * 1 ether;

        uint256 e = 1 ether;
        uint256 e10 = 1 ether / 10;
        uint256 e100 = 1 ether / 100;
        uint256 e1000 = 1 ether / 1000;
        uint256 e10000 = 1 ether / 10000;

        uint256 bp = 1 ether;

    /* sellAmountStep - simulate decrease users amount (msg.value) when buyPrice is 1 ether */
    function sellAmountStep() public
        returns (uint256, uint256, uint256, uint256, uint256)
    {
        uint256 _amount1 = e * DEC / (bp);
         uint256 _amount2 = e10 * DEC/ (bp);
          uint256 _amount3 = e100 * DEC/ (bp);
           uint256 _amount4 = e1000 * DEC / (bp);
            uint256 _amount5 = e10000 * DEC/ (bp);

        return (_amount1, _amount2, _amount3, _amount4, _amount5);
    }

    uint256 public price = 1 * DEC / 2000;

    /* sellPriceStep - simulate decrease users amount (msg.value) when buyPrice less then 1 ether */
    function sellPriceStep() public
        returns (uint256, uint256, uint256, uint256, uint256)
    {
        uint256 _amount1 = e * DEC / (price);
         uint256 _amount2 = e10 * DEC/ (price);
          uint256 _amount3 = e100 * DEC/ (price);
           uint256 _amount4 = e1000 * DEC / (price);
            uint256 _amount5 = e10000 * DEC/ (price);

        return (_amount1, _amount2, _amount3, _amount4, _amount5);
    }

    uint256 public price2 = 2 * 1 ether;

    /* sellPriceStep2 - simulate decrease users amount (msg.value) when buyPrice more then 1 ether */
    function sellPriceStep2() public
        returns (uint256, uint256, uint256, uint256, uint256)
    {
        uint256 _amount1 = e * DEC / (price2);
         uint256 _amount2 = e10 * DEC/ (price2);
          uint256 _amount3 = e100 * DEC/ (price2);
           uint256 _amount4 = e1000 * DEC / (price2);
            uint256 _amount5 = e10000 * DEC/ (price2);

        return (_amount1, _amount2, _amount3, _amount4, _amount5);
    }

}
