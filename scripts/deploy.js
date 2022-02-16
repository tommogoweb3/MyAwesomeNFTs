
const main = async () => {
    const nftContractFactory = await hre.ethers.getContractFactory('MyAwesomeNFTs'); //compile contract and generate afrtifacts
    const nftContract = await nftContractFactory.deploy();
    await nftContract.deployed();
    console.log("Contract deployed to:", nftContract.address);

    let txn = await nftContract.makeAnAwesomeNFT(); // call mint function
    await txn.wait(); // wait for it to be mined
    console.log("Minted NFT #1");

    txn = await nftContract.makeAnAwesomeNFT(); // another mint here
    await txn.wait();
    console.log("Minted NFT #2");
};

const runMain = async() => {
    try {
        await main();
        process.exit(0);
    }   catch (error) {
        console.log(error);
        process.exit(1);
    }
};

runMain();