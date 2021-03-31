const ConvertLib = artifacts.require("ConvertLib");
const MetaVote2 = artifacts.require("MetaVote2");

module.exports = function(deployer) {
  deployer.deploy(ConvertLib);
  deployer.link(ConvertLib, MetaVote2);
  deployer.deploy(MetaVote2);
};
