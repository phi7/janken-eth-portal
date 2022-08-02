// const main = async () => {
//   const [deployer] = await hre.ethers.getSigners();
//   const accountBalance = await deployer.getBalance();

//   console.log("Deploying contracts with account: ", deployer.address);
//   console.log("Account balance: ", accountBalance.toString());

//   const waveContractFactory = await hre.ethers.getContractFactory("WavePortal");
//   /* コントラクトに資金を提供できるようにする */
//   const waveContract = await waveContractFactory.deploy({
//     value: hre.ethers.utils.parseEther("0.001"),
//   });

//   await waveContract.deployed();

//   console.log("WavePortal address: ", waveContract.address);
// };

// const runMain = async () => {
//   try {
//     await main();
//     process.exit(0);
//   } catch (error) {
//     console.error(error);
//     process.exit(1);
//   }
// };

// runMain();

const main = async () => {
  const [deployer] = await hre.ethers.getSigners();
  const accountBalance = await deployer.getBalance();

  console.log("Deploying contracts with account: ", deployer.address);
  console.log("Account balance: ", accountBalance.toString());

  const jankenContractFactory = await hre.ethers.getContractFactory("JankenPortal");
  /* コントラクトに資金を提供できるようにする */
  const jankenContract = await jankenContractFactory.deploy({
    value: hre.ethers.utils.parseEther("0.0001"),
  });

  await jankenContract.deployed();

  console.log("JankenPortal address: ", jankenContract.address);
};

const runMain = async () => {
  try {
    await main();
    process.exit(0);
  } catch (error) {
    console.error(error);
    process.exit(1);
  }
};

runMain();