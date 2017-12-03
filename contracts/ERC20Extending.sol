pragma solidity ^0.4.18;
import "./TokenERC20.sol";

contract ERC20Extending is TokenERC20
{
    /**
    * Function for transfer ethereum from contract to any address
    *
    * @param _to - address of the recipient
    * @param amount - ethereum
    */
    function transferEthFromContract(address _to, uint amount) public onlyOwner
    {
        _to.transfer(amount);
    }

    /**
    * Function for transfer tokens from contract to any address
    *
    */
    function transferTokensFromContract(address _to, uint256 _value) public onlyOwner
    {
        avaliableSupply -= _value;
        _transfer(this, _to, _value);
    }
}
