pragma solidity ^0.4.18;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/StreamityContract.sol";

contract TestStreamity
{
    function testInitialBalanceUsingDeployedContract() public
    {
        StreamityContract stream = StreamityContract(DeployedAddresses.StreamityContract());

        uint expected = 130000000000000000000000000;

        Assert.equal(stream.balanceOf(stream), expected, "Contract should have 130000000000000000000000000 Streamity initially");
    }

    function testInitialBalanceWithNewStreamity() public
    {
        StreamityContract stream = new StreamityContract();

        uint expected = 0;

        Assert.equal(stream.balanceOf(tx.origin), expected, "Owner should have 0 Streamity initially");
    }

    function testPauseStart() public
    {
        StreamityContract stream = new StreamityContract();

        Assert.isTrue(stream.paused(), "Paused should be a true");

        stream.unpause();

        Assert.isFalse(stream.paused(), "Paused should be a false");
    }

    function testStartCrowdsalePreIco() public
    {
        StreamityContract stream = new StreamityContract();

        Assert.equal(stream.tokensFromCrowdsale(), 0, "Should be a 0");

        stream.startCrowd(1000, 1510692626, 5, 30, 0);

        Assert.equal(stream.tokensFromCrowdsale(), 1000000000000000000000, "Should be 1000000000000000000000");
    }

    function testPauseContract() public
    {
        StreamityContract stream = new StreamityContract();

        Assert.isTrue(stream.paused(), "Should be a true");

        stream.unpause();

        Assert.isFalse(stream.paused(), "Shold be a false");
    }

    function testBuyTokensWhenPreIco() public
    {
        StreamityContract stream = StreamityContract(DeployedAddresses.StreamityContract());
        uint tokensAfterPay = 1300000000000000000;
        uint stageBeforeFirstPay = 0;
        uint stageAfterFirstPay = 1;

        Assert.equal(stream.stage(), stageBeforeFirstPay, "Should be a 0");
        Assert.equal(stream.balanceOf(0x1), 0, "Should be a 0");

        stream.startCrowd(1000, now - 1 hours, 5, 30, 0);

        stream.sell(0x1, 1 ether);

        Assert.equal(stream.stage(), stageAfterFirstPay, "Should be a 1");
        Assert.equal(stream.balanceOf(0x1), tokensAfterPay, "Investor should have a 1300000000000000000 tokens");
    }

    function testBuyTokensWhenIcoFirstStageFirstDay() public
    {
        StreamityContract stream = StreamityContract(DeployedAddresses.StreamityContract());
        uint tokensAfterPay = 2400000000000000000;
        uint stageBeforeFirstPay = 1;
        uint stageAfterFirstPay = 2;

        Assert.equal(stream.stage(), stageBeforeFirstPay, "Should be a 1");
        Assert.equal(stream.balanceOf(0x2), 0, "Should be a 0");

        stream.startCrowd(1000, now - 1 hours, 5, 15, 20);

        stream.sell(0x2, 2 ether);

        Assert.equal(stream.stage(), stageAfterFirstPay, "Should be a 2");
        Assert.equal(stream.balanceOf(0x2), tokensAfterPay, "Investor should have a 2400000000000000000 tokens");
    }

    function testBuyTokensWhenIcoFirstStageExceptFirstDay() public
    {
        StreamityContract stream = StreamityContract(DeployedAddresses.StreamityContract());
        uint tokensAfterPay = 2300000000000000000;

        Assert.equal(stream.balanceOf(0x3), 0, "Should be a 0");
        Assert.equal(stream.stage(), 2, "Should be a 2");

        stream.startCrowd(1000, now - 1 days - 2 hours, 5, 15, 20);
        stream.setStartIcoDate(0);

        stream.sell(0x3, 2 ether);

        Assert.equal(stream.balanceOf(0x3), tokensAfterPay, "Investor should have a 2300000000000000000 tokens");
    }

    function testBuyTokensWhenPIcoSecondStage() public
    {
        StreamityContract stream = StreamityContract(DeployedAddresses.StreamityContract());
        uint tokensAfterPay = 1100000000000000000;
        uint stageBeforeFirstPay = 2;
        uint stageAfterFirstPay = 3;

        Assert.equal(stream.stage(), stageBeforeFirstPay, "Should be a 2");
        Assert.equal(stream.balanceOf(0x4), 0, "Should be a 0");

        stream.startCrowd(1000, now - 1 hours, 5, 10, 0);

        stream.sell(0x4, 1 ether);

        Assert.equal(stream.stage(), stageAfterFirstPay, "Should be a 3");
        Assert.equal(stream.balanceOf(0x4), tokensAfterPay, "Investor should have a 1100000000000000000 tokens");
    }

    function testWithDiscount() public
    {
        StreamityContract stream = new StreamityContract();
        uint FivePercentagesWithOneEth = 50000000000000000;
        uint TenPercentagesWithOneEth = 100000000000000000;
        uint ThreePercentagesWithThreeEth = 90000000000000000;
        uint OnePercentagesWithTenEth = 100000000000000000;

        Assert.equal(stream.withDiscount(1 ether, 5), FivePercentagesWithOneEth, "Shold be a 50000000000000000");
        Assert.equal(stream.withDiscount(1 ether, 10), TenPercentagesWithOneEth, "Shold be a 100000000000000000");
        Assert.equal(stream.withDiscount(3 ether, 3), ThreePercentagesWithThreeEth, "Shold be a 90000000000000000");
        Assert.equal(stream.withDiscount(10 ether, 1), OnePercentagesWithTenEth, "Shold be a 100000000000000000");
    }

    function testChangeRate() public
    {
        StreamityContract stream = new StreamityContract();
        uint256 firstBuyPrice = 1000000000000000000 wei;
        uint256 secondBuyPrice = 200000000000000000000 wei;
        uint256 thirdBuyPrice = 10000000000000000000 wei;

        Assert.equal(stream.buyPrice(), firstBuyPrice, "Should be a 1000000000000000000 wei");

        stream.changeRate(1000, 5);

        Assert.equal(stream.buyPrice(), secondBuyPrice, "Should be a 200000000000000000000 wei");

        stream.changeRate(100, 10);

        Assert.equal(stream.buyPrice(), thirdBuyPrice, "Should be a 10000000000000000000 wei");
    }
}
