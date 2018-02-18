var MyTradingToken = artifacts.require("TradingToken");

module.exports = function(deployer) {
  // deployment steps
  deployer.deploy(MyTradingToken);
};
