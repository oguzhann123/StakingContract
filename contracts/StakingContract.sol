// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v5.0.0) (token/ERC20/IERC20.sol)

pragma solidity ^0.8.20;

contract StakingContract{

 IERC20 public  stakingToken;
 IERC20 public  rewardsToken;

 address public owner;

 uint constant public rewardPerToken= 1;
 mapping (address=>uint) public balanceOf;  // ne kadar token stake ettgimizi tutucagiz
 mapping (address=>uint) public durations; // stake ettigi sureleri tutuyoruz
 mapping (address=>uint) public rewards; // odul miktarlari tutuyoruz




     constructor(address _stakingToken, address _rewardsToken) {
     owner=msg.sender;
     stakingToken = IERC20(_stakingToken);
      rewardsToken = IERC20(_rewardsToken); 
    }

      modifier updateReward(address _account){
     rewards[_account]+=calculate(msg.sender);
        durations[_account]=block.timestamp;
        _;
    }

  
 function calculate(address _account) view internal   returns (uint){
        uint duration = block.timestamp - durations[_account];
        return  balanceOf[_account] * duration * rewardPerToken;
    }
   

    function stake(uint _amount) external updateReward(msg.sender) {
        require(_amount>0,"amount = 0");

        balanceOf[msg.sender]= balanceOf[msg.sender] + _amount;
        stakingToken.transferFrom(msg.sender,address(this),_amount);
    }

    function withdraw(uint _amount) external updateReward(msg.sender){
      require(_amount>0,"amount = 0");
     require(balanceOf[msg.sender]>0,"Your balancne equal 0 ");
      balanceOf[msg.sender]= balanceOf[msg.sender] - _amount;
      stakingToken.transfer(msg.sender, _amount);



    }

    function getRewards() external  updateReward(msg.sender){
        uint reward = rewards[msg.sender];
        require(reward>0,"You don't have rewards.");
        rewards[msg.sender]=0;
        rewardsToken.transfer(msg.sender, reward);


    }

}

   

interface IERC20 {
  
    event Transfer(address indexed from, address indexed to, uint256 value);

 
    event Approval(address indexed owner, address indexed spender, uint256 value);

    
    function totalSupply() external view returns (uint256);

    
    function balanceOf(address account) external view returns (uint256);

    
    function transfer(address to, uint256 value) external returns (bool);

    
    function allowance(address owner, address spender) external view returns (uint256);

    
    function approve(address spender, uint256 value) external returns (bool);

   
    function transferFrom(address from, address to, uint256 value) external returns (bool);
}