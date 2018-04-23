pragma solidity ^0.4.18;


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

    function addTokenAndStrategy(string strategyName,address tokenName) {
      strategies.push(strategyName);
      tokens.push(tokenName);
    }

    function getNumberRegisteredStrategies() public constant returns (uint) {
      return(strategies.length);
    }

    function getNumberRegisteredTokens() public constant returns (uint) {
      return(tokens.length);
    }

}
