pragma solidity ^0.4.18;

import "./SlotManager.sol";
import "./TradingToken.sol";

contract BlockchainSpeaker{

    address token;
    string name;
    string[] strategies;
    address[] tokens;

    function BlockchainSpeaker(address _token, string _name){
        token = _token;
        name = _name;
    }

    function addStrategy(string strategyName) {
      strategies.push(strategyName);
    }

    function addToken(address tokenName) {
      tokens.push(tokenName);
    }


}
