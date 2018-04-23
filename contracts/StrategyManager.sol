pragma solidity ^0.4.18;

contract StrategyManager{

    address public owner;
    string public name;      //the name of the strategy
    string[] strategies;

    //mapping(bytes15 => StrategyPublisher) public stratRegistry;
    mapping(address => string) public stratRegistry;

    event newRegister(string name, address stratAddress);

    modifier onlyOwner(){
        require(msg.sender==owner);
        _;
    }

    function StrategyManager(string _managerName){
      name = _managerName;
    }

    function registerStrategy(address _newAddress, string _stratName) onlyOwner {
      //stratRegistry[_newAddress] = _stratName;
      //strategies.push(_stratName);
      //newRegister(_stratName, _newAddress);
    }

    function getNumberRegisteredStrategies() public constant returns (uint) {
      return(strategies.length);
    }

    function getRegisteredStrategyName(uint index) public constant returns (string) {
      return(strategies[index]);
    }

    function getStrategyAddress(address _stratAddress) public constant returns (string){
      string stratName = stratRegistry[_stratAddress];
      return(stratName);
    }

}
