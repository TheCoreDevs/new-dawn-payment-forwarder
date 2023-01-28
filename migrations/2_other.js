const NewDawnPaymentForwarder = artifacts.require("NewDawnPaymentForwarder");

module.exports = function (deployer) {
  deployer.deploy(NewDawnPaymentForwarder, "0x4ED50664941D36dE95Be32CB9ff849D2E9658145", 1, 1, 1, 1);
};
