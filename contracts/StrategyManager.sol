pragma solidity ^0.4.18;

contract StrategyManager{

    address public owner;
    bytes15 public name;      //the name of the strategy
    bytes15[] strategies;

    //mapping(string => StrategyPublisher) public stratRegistry;
    //mapping(bytes15 => StrategyPublisher) public stratRegistry;
    mapping(bytes15 => address) public stratRegistry;

    event newRegister(bytes15 name, address stratAddress);

    modifier onlyOwner(){
        require(msg.sender==owner);
        _;
    }

    function StrategyManager(bytes15 _managerName){
      name = _managerName;
      owner = msg.sender;
    }

    function registerStrategy(bytes15 _stratName,address _newAddress) onlyOwner {
      //stratRegistry[_newAddress] = _stratName;
      stratRegistry[_stratName] = _newAddress;
      strategies.push(_stratName);
      newRegister(_stratName, _newAddress);
    }

    function getNumberRegisteredStrategies() public constant returns (uint) {
      return(strategies.length);
    }

    function getRegisteredStrategyName(uint index) public constant returns (bytes15) {
      return(strategies[index]);
    }

    function getStrategyAddress(bytes15 _stratName) public constant returns (address){
      address _stratAddress = stratRegistry[_stratName];
      return(_stratAddress);
    }

}
