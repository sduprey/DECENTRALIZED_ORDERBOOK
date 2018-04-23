pragma solidity ^0.4.6;

contract StrategyCrud {

  struct StrategyStruct {
    address strategyAddress;
    uint strategyCategory;
    uint index;
  }

  mapping(bytes15 => StrategyStruct) private strategyStructs;
  bytes15[] private strategyIndex;

  event LogNewUser   (bytes15 indexed strategyName, uint index, address strategyAddress, uint strategyCategory);
  event LogUpdateUser(bytes15 indexed strategyName, uint index, address strategyAddress, uint strategyCategory);
  event LogDeleteUser(bytes15 indexed strategyName, uint index);

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
    public
    returns(uint index)
  {
    if(isStrategy(strategyName)) throw;
    strategyStructs[strategyName].strategyAddress = strategyAddress;
    strategyStructs[strategyName].strategyCategory   = strategyCategory;
    strategyStructs[strategyName].index     = strategyIndex.push(strategyName)-1;
    LogNewUser(
        strategyName,
        strategyStructs[strategyName].index,
        strategyAddress,
        strategyCategory);
    return strategyIndex.length-1;
  }

  function deleteUser(bytes15 strategyName)
    public
    returns(uint index)
  {
    if(!isStrategy(strategyName)) throw;
    uint rowToDelete = strategyStructs[strategyName].index;
    bytes15 keyToMove = strategyIndex[strategyIndex.length-1];
    strategyIndex[rowToDelete] = keyToMove;
    strategyStructs[keyToMove].index = rowToDelete;
    strategyIndex.length--;
    LogDeleteUser(
        strategyName,
        rowToDelete);
    LogUpdateUser(
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
    public
    returns(bool success)
  {
    if(!isStrategy(strategyName)) throw;
    strategyStructs[strategyName].strategyAddress = strategyAddress;
    LogUpdateUser(
      strategyName,
      strategyStructs[strategyName].index,
      strategyAddress,
      strategyStructs[strategyName].strategyCategory);
    return true;
  }

  function updateStrategyCategory(bytes15 strategyName, uint strategyCategory)
    public
    returns(bool success)
  {
    if(!isStrategy(strategyName)) throw;
    strategyStructs[strategyName].strategyCategory = strategyCategory;
    LogUpdateUser(
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
