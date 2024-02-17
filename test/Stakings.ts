import {
  time,
  loadFixture,
} from "@nomicfoundation/hardhat-toolbox/network-helpers";
import { anyValue } from "@nomicfoundation/hardhat-chai-matchers/withArgs";
import { expect } from "chai";
import { ethers } from "hardhat";

describe("Save Token", function () {

  async function deployStakings() {

    // Contracts are deployed using the first signer/account by default
    const [owner, otherAccount] = await ethers.getSigners();
    const DepositAmount = 10;
    const testAmount= 5;

       //deploying the token
    const CaveToken= await ethers.getContractFactory("CaveToken");
    const token = await CaveToken.deploy();

        //deploying the contract
    const Stakings = await ethers.getContractFactory("SaveERC20");
    const stakings = await Stakings.deploy(token.target);

    return { stakings,token,owner,otherAccount,DepositAmount,testAmount};

  }


  describe("checking it's not address 0 at the stake function", async () => {

    it("it should not be address 0", async () => {
      const {owner} = await loadFixture(deployStakings);
      expect(owner.address).not.equal(ethers.ZeroAddress);

    })
  })
})
