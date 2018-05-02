pragma solidity ^0.4.18;

contract StrategyCrud {

  bytes15 managerName;
  address owner;

  struct StrategyStruct {
    address strategyAddress;
    uint strategyCategory;
    uint index;
  }

  mapping(bytes15 => StrategyStruct) private strategyStructs;
  bytes15[] private strategyIndex;

  event LogNewStrategy   (bytes15 indexed strategyName, uint index, address strategyAddress, uint strategyCategory);
  event LogUpdateStrategy(bytes15 indexed strategyName, uint index, address strategyAddress, uint strategyCategory);
  event LogDeleteStrategy(bytes15 indexed strategyName, uint index);

  modifier onlyOwner(){
      require(msg.sender==owner);
      _;
  }

  function StrategyCrud(bytes15 _name){
      owner = msg.sender;
      managerName = _name;
  }

  function isStrategy(bytes15 strategyName)
    public
    constant
    returns(bool isIndeed)
  {
    if(strategyIndex.length == 0) return false;
    return (strategyIndex[strategyStructs[strategyName].index] == strategyName);
  }

  function insertStrategy(
    bytes15 strategyName,
    address strategyAddress,
    uint    strategyCategory)
    onlyOwner
    public
    returns(uint index)
  {
    if(isStrategy(strategyName)) throw;
    strategyStructs[strategyName].strategyAddress = strategyAddress;
    strategyStructs[strategyName].strategyCategory   = strategyCategory;
    strategyStructs[strategyName].index     = strategyIndex.push(strategyName)-1;
    emit LogNewStrategy(
        strategyName,
        strategyStructs[strategyName].index,
        strategyAddress,
        strategyCategory);
    return strategyIndex.length-1;
  }

  function deleteStrategy(bytes15 strategyName)
    onlyOwner
    public
    returns(uint index)
  {
    if(!isStrategy(strategyName)) throw;
    uint rowToDelete = strategyStructs[strategyName].index;
    bytes15 keyToMove = strategyIndex[strategyIndex.length-1];
    strategyIndex[rowToDelete] = keyToMove;
    strategyStructs[keyToMove].index = rowToDelete;
    strategyIndex.length--;
    emit LogDeleteStrategy(
        strategyName,
        rowToDelete);
    emit LogUpdateStrategy(
        keyToMove,
        rowToDelete,
        strategyStructs[keyToMove].strategyAddress,
        strategyStructs[keyToMove].strategyCategory);
    return rowToDelete;
  }

  function getStrategy(bytes15 strategyName)
    public
    constant
    returns(address strategyAddress, uint strategyCategory, uint index)
  {
    if(!isStrategy(strategyName)) throw;
    return(
      strategyStructs[strategyName].strategyAddress,
      strategyStructs[strategyName].strategyCategory,
      strategyStructs[strategyName].index);
  }

  function updateStrategyAddress(bytes15 strategyName, address strategyAddress)
    onlyOwner
    public
    returns(bool success)
  {
    if(!isStrategy(strategyName)) throw;
    strategyStructs[strategyName].strategyAddress = strategyAddress;
    emit LogUpdateStrategy(
      strategyName,
      strategyStructs[strategyName].index,
      strategyAddress,
      strategyStructs[strategyName].strategyCategory);
    return true;
  }

  function updateStrategyCategory(bytes15 strategyName, uint strategyCategory)
    onlyOwner
    public
    returns(bool success)
  {
    if(!isStrategy(strategyName)) throw;
    strategyStructs[strategyName].strategyCategory = strategyCategory;
    emit LogUpdateStrategy(
      strategyName,
      strategyStructs[strategyName].index,
      strategyStructs[strategyName].strategyAddress,
      strategyCategory);
    return true;
  }

  function getStrategyCount()
    public
    constant
    returns(uint count)
  {
    return strategyIndex.length;
  }

  function getStrategyAtIndex(uint index)
    public
    constant
    returns(bytes15 strategyName)
  {
    return strategyIndex[index];
  }

}
