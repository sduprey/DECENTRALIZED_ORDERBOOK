var MyTradingToken = artifacts.require("TradingToken");

module.exports = function(deployer) {
  deployer.deploy(MyTradingToken.address)
};
