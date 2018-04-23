pragma solidity ^0.4.18;

contract StrategyManager{

    address public owner;
    bytes15 public name;      //the name of the strategy
    bytes15[] strategies;

    //mapping(bytes15 => StrategyPublisher) public stratRegistry;
    mapping(bytes15 => string) public stratRegistry;

    event newRegister(bytes15 name, string stratAddress);


    modifier onlyOwner(){
        require(msg.sender==owner);
        _;
    }

    function StrategyManager(bytes15 _managerName){
      name = _managerName;
    }

    function registerNewStrategy(string _newAddress, bytes15 _stratName) onlyOwner {
      //stratRegistry[_stratName] = _newAddress;
      //strategies.push(_stratName);
      //newRegister(_stratName, _newAddress);
    }

    function getAllRegisteredStrategies() public constant returns (bytes15[]) {
      return(strategies);
    }

    function getStrategyAddress(bytes15 _stratName) public constant returns (string){
      string myAddress = stratRegistry[_stratName];
      return  myAddress;
    }

}
