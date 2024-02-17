// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

 import "./IERC20.sol";

  error NO_ENOUGH_FUNDS();
  error NO_ADDRESS_0_ALLOWED();
  error TIME_CONFLICT_ERROR();

contract Stakings {
   

    IERC20 public token;
    address public owner;
    uint256 public stakingDuration;
    
    constructor(IERC20 _token) {

    token=IERC20(_token);
    owner=msg.sender;
    }

   mapping (address=>uint)public stakedBalance;
   mapping (address=>uint)public rewards;
   mapping (address=>uint)public  lastStakedTime;

    function stake(uint256 amount) external {
        // require(amount>0, "No enough funds");
        if (msg.sender==address(0)) {
            revert NO_ADDRESS_0_ALLOWED();
            
        }

        if (amount<= 0) {
            revert NO_ENOUGH_FUNDS();
            
        }

        require(token.balanceOf(msg.sender) >=  amount,"no enough token");
        require(token.transferFrom(msg.sender, address(this), amount),"failed to transfer");

        stakedBalance[msg.sender]= stakedBalance[msg.sender] + amount;
        lastStakedTime[msg.sender]= block.timestamp;
    }

    function unstake(uint256 amount)external  {
        // require(msg.sender != address(0),"you can't withdraw");
          if (msg.sender==address(0)) {
            revert NO_ADDRESS_0_ALLOWED();
            
        }
        // require(amount>0, "No enough funds");
        if (amount<= 0) {
            revert NO_ENOUGH_FUNDS();
            
        }
        // require(block.timestamp >= lastStakedTime[msg.sender]);
        if ((lastStakedTime[msg.sender])>block.timestamp){
            
            revert TIME_CONFLICT_ERROR();
        }
          
        onlyOwner();
        
       uint256 _stakedBalance= stakedBalance[msg.sender];

        require(_stakedBalance >= amount,"no enough funds");

        stakedBalance[msg.sender] -= amount ;

        require(token.transfer(msg.sender, amount),"successfully  unstake");
        
    }

    function ClaimReward(address user)external  {
        onlyOwner();
        
        uint reward=CalculateReward(user);

        rewards[user] += reward;

        require(token.transfer(user, reward)," successful");
        
    }

    function CalculateReward(address user) internal  view returns (uint256) {
        uint256 timeElapsed=  block.timestamp - lastStakedTime[msg.sender];
        // uint256 myReward= stakedBalance[user];

        uint256 percentStake=  stakedBalance[user] * 10/ 100 
        
        *(timeElapsed/60);

        return percentStake;
        
    }

    function onlyOwner() private view  {
        require(owner == msg.sender,"Only Owner can withdraw");
    }
}