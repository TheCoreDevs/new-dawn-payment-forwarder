const NewDawnPaymentForwarder = artifacts.require("NewDawnPaymentForwarder");

contract("NewDawnPaymentForwarder", (accounts) => {
    it("toggle trading", async() => {
        const Instance = await NewDawnPaymentForwarder.deployed();
        await Instance.toggleTrading();
        const state = await Instance.tradingToggle.call();
        assert(state)
    })

    it("make direct offer", async() => {
        const Instance = await NewDawnPaymentForwarder.deployed();
        const txnId = 1;
        const nftId = 1;
        const to = accounts[2];
        const signer = accounts[1];
        const treasury = accounts[0];

        const msg = await Instance.getMsgDirect.call(txnId, nftId, to, signer);
        const sig = await web3.eth.sign(msg, signer);

        const oldBal = parseInt(await web3.eth.getBalance(treasury));
        await Instance.makeDirectOffer(txnId, nftId, to, sig, {value: 1, from: signer});
        const newBal = parseInt(await web3.eth.getBalance(treasury));

        assert.equal(
            newBal,
            oldBal + 1
        )
    });

    it("take direct offer", async() => {
        const Instance = await NewDawnPaymentForwarder.deployed();
        const txnId = 1;
        const nftId = 1;
        const to = accounts[2];
        const signer = accounts[1];
        const from = signer;
        const treasury = accounts[0];

        const msg = await Instance.getMsgDirect.call(txnId, nftId, to, signer);
        const sig = await web3.eth.sign(msg, signer);

        const oldBal = parseInt(await web3.eth.getBalance(treasury));
        await Instance.acceptDirectOffer(txnId, nftId, from, sig, {value: 1, from: to});
        const newBal = parseInt(await web3.eth.getBalance(treasury));

        assert.equal(
            newBal,
            oldBal + 1
        )
    });

    it("make global offer", async() => {
        const Instance = await NewDawnPaymentForwarder.deployed();
        const txnId = 1;
        const nftId = 1;
        const signer = accounts[1];
        const treasury = accounts[0];

        const msg = await Instance.getMsgGlobal.call(txnId, nftId, signer);
        const sig = await web3.eth.sign(msg, signer);

        const oldBal = parseInt(await web3.eth.getBalance(treasury));
        await Instance.makeGlobalOffer(txnId, nftId, sig, {value: 1, from: signer});
        const newBal = parseInt(await web3.eth.getBalance(treasury));

        assert.equal(
            newBal,
            oldBal + 1
        )
    });

    it("take global offer", async() => {
        const Instance = await NewDawnPaymentForwarder.deployed();
        const txnId = 1;
        const nftId = 1;
        const taker = accounts[2]
        const signer = accounts[1];
        const treasury = accounts[0];

        const msg = await Instance.getMsgGlobal.call(txnId, nftId, signer);
        const sig = await web3.eth.sign(msg, signer);

        const oldBal = parseInt(await web3.eth.getBalance(treasury));
        await Instance.acceptGlobalOffer(txnId, nftId, signer, sig, {value: 1, from: taker});
        const newBal = parseInt(await web3.eth.getBalance(treasury));

        assert.equal(
            newBal,
            oldBal + 1
        )
    });
});