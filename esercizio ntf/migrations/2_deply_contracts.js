const Migrations = artifacts.require("NTF");

module.exports = function (deployer) {
  deployer.deploy(Migrations);
};
