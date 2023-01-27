// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

contract NewDawnMarketplace {

    address public admin;
    address payable public treasury;
    bool public tradingToggle;

    uint internal _directOfferPrice;
    uint internal _directAcceptancePrice;
    uint internal _globalOfferPrice;
    uint internal _globalAcceptancePrice;

    event NewAdmin(address oldAdmin, address newAdmin);
    event NewTreasury(address oldTreasury, address newTreasury);
    event UpdatedTradingStatus(bool status);
    event PriceChange(string indexed _type, uint newPrice);
    event ActivityEvents(string indexed _type, address indexed txnSender);

    modifier onlyAdmin {
        require(msg.sender == admin, "Only Admin");
        _;
    }

    // requires `tradingToggle` to be true
    modifier tradingEnabled {
        require(tradingToggle, "Trading is disabled");
        _;
    }

    constructor(
        address payable treasuryAddress,
        uint directOfferPriceInWei,
        uint directAcceptancePriceInWei,
        uint globalOfferPriceInWei,
        uint globalAcceptancePriceInWei
    ) {
        admin = msg.sender;
        treasury = treasuryAddress;
        setAllPrices(directOfferPriceInWei, directAcceptancePriceInWei, globalOfferPriceInWei, globalAcceptancePriceInWei);
    }

    function makeDirectOffer() external payable tradingEnabled {
        require(msg.value == _directOfferPrice, "Invalid Eth Amount");
        _transferMsgValueToTreasury();
        emit ActivityEvents("Direct Offer", msg.sender);
    }

    function acceptDirectOffer() external payable tradingEnabled {
        require(msg.value == _directAcceptancePrice, "Invalid Eth Amount");
        _transferMsgValueToTreasury();
        emit ActivityEvents("Direct Acceptance", msg.sender);
    }

    function makeGlobalOffer() external payable tradingEnabled {
        require(msg.value == _globalOfferPrice, "Invalid Eth Amount");
        _transferMsgValueToTreasury();
        emit ActivityEvents("Global Offer", msg.sender);
    }

    function acceptGlobalOffer() external payable tradingEnabled {
        require(msg.value == _globalAcceptancePrice, "Invalid Eth Amount");
        _transferMsgValueToTreasury();
        emit ActivityEvents("Global Acceptance", msg.sender);
    }

    // ADMIN FUNCTIONS
    
    function changeAdmin(address newAdmin) external onlyAdmin {
        require(newAdmin != address(0), "Admin cannot be set to zero");
        address oldAdmin = admin;
        admin = newAdmin;
        emit NewAdmin(oldAdmin, newAdmin);
    }

    function setTreasuryAddress(address payable newAddress) external onlyAdmin {
        require(newAddress != address(0), "Treasury cannot be set to zero");
        address oldTreasury = treasury;
        treasury = newAddress;
        emit NewTreasury(oldTreasury, newAddress);
    }

    // switch for trading toggle
    function toggleTrading() external onlyAdmin {
        tradingToggle = !tradingToggle;
        emit UpdatedTradingStatus(tradingToggle);
    }

    function changeDirectOfferPrice(uint priceInWei) external onlyAdmin {
        _directOfferPrice = priceInWei;
        emit PriceChange("Direct Offer", priceInWei);
    }

    function changeDirectAcceptancePrice(uint priceInWei) external onlyAdmin {
        _directAcceptancePrice = priceInWei;
        emit PriceChange("Direct Acceptance", priceInWei);
    }

    function changeGlobalOfferPrice(uint priceInWei) external onlyAdmin {
        _globalOfferPrice = priceInWei;
        emit PriceChange("Global Offer", priceInWei);
    }

    function changeGlobalAcceptancePrice(uint priceInWei) external onlyAdmin {
        _globalAcceptancePrice = priceInWei;
        emit PriceChange("Global Acceptance", priceInWei);
    }

    function changeAllPrices(
        uint directOfferPriceInWei,
        uint directAcceptancePriceInWei,
        uint globalOfferPriceInWei,
        uint globalAcceptancePriceInWei
    ) external onlyAdmin {
        setAllPrices(directOfferPriceInWei, directAcceptancePriceInWei, globalOfferPriceInWei, globalAcceptancePriceInWei);
        emit PriceChange("Direct Offer", directOfferPriceInWei);
        emit PriceChange("Direct Acceptance", directAcceptancePriceInWei);
        emit PriceChange("Global Offer", globalOfferPriceInWei);
        emit PriceChange("Global Acceptance", globalAcceptancePriceInWei);
    }

    
    // GETTERS
    /*
     * @dev returns all price values
     */
    function returnPrices() external view returns(uint directOffer, uint directAcceptance, uint globalOffer, uint globalAcceptance) {
        directOffer = _directOfferPrice;
        directAcceptance = _directAcceptancePrice;
        globalOffer = _globalOfferPrice;
        globalAcceptance = _globalAcceptancePrice;
    }

    // PRIVATE FUNCTIONS

    function _transferMsgValueToTreasury() private {
        (bool success, ) = treasury.call{value: msg.value, gas: 3000}("");
        require(success, "Transfer to treasury failed");
    }

    function setAllPrices(
        uint directOfferPriceInWei,
        uint directAcceptancePriceInWei,
        uint globalOfferPriceInWei,
        uint globalAcceptancePriceInWei
    ) private {
        _directOfferPrice = directOfferPriceInWei;
        _directAcceptancePrice = directAcceptancePriceInWei;
        _globalOfferPrice = globalOfferPriceInWei;
        _globalAcceptancePrice = globalAcceptancePriceInWei;
    }
}