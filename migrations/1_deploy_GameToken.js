//固定总量代币
const GameToken = artifacts.require("GameToken");

module.exports = function(deployer) {
    deployer.deploy(GameToken);
};
