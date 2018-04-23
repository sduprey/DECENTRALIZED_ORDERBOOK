pragma solidity ^0.4.18;

contract StrategyManager{

    address public owner;
    bytes10 public name;      //the name of the strategy
    bytes10[] strategies;

    //mapping(bytes15 => StrategyPublisher) public stratRegistry;
    //mapping(bytes10 => address) public stratRegistry;

    event newRegister(bytes10 name, address stratAddress);


    modifier onlyOwner(){
        require(msg.sender==owner);
        _;
    }

    function StrategyManager(bytes10 _managerName){
      name = _managerName;
    }

    function registerNewStrategy(address _newAddress, bytes10 _stratName) onlyOwner {
      //stratRegistry[_stratName] = _newAddress;
      //strategies.push(_stratName);
      //newRegister(_stratName, _newAddress);
    }

    function getNumberRegisteredStrategies() public constant returns (uint) {
      return(strategies.length);
    }

//    function getStrategyAddress(bytes10 _stratName) public constant returns (address){
//      address myAddress = stratRegistry[_stratName];
//      return(myAddress);
//    }

}
