const ConvertLib = artifacts.require("ConvertLib");
const MetaVote1 = artifacts.require("MetaVote1");

module.exports = function(deployer) {
  deployer.deploy(ConvertLib);
  deployer.link(ConvertLib, MetaVote1);
  deployer.deploy(MetaVote1);
};
