var Migrations = artifacts.require("./StreamityContract.sol");

module.exports = function(deployer) {
  deployer.deploy(Migrations);
};
