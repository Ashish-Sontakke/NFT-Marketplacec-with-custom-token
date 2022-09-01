const MyToken = artifacts.require("MyToken");
const NFT = artifacts.require("NFT");
const Marketplace = artifacts.require("Marketplace");

module.exports = async function (deployer) {
  await deployer.deploy(NFT);
  await deployer.deploy(MyToken, "100000000000000000000000");

  await deployer.deploy(Marketplace, NFT.address, MyToken.address);
};
