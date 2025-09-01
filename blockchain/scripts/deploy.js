// scripts/deploy.js

const hre = require("hardhat");

async function main() {
  const LoanManager = await hre.ethers.getContractFactory("LoanManager");
  const loanManager = await LoanManager.deploy();

  await loanManager.waitForDeployment();

  console.log("✅ LoanManager deployed to:", await loanManager.getAddress());
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
