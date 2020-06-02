pragma solidity ^0.5.4;
import 'https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/math/SafeMath.sol';


contract Donation {
    using SafeMath for uint256;

    campaign[] private campaigns;

    event campaignStarted(
        address contractAddress,
        address campaignStarter,
        string campaignTitle,
        string campaignDesc,
        uint256 deadline,
        uint256 goalAmount
    );

    function startcampaign(
        string calldata title,
        string calldata description,
        uint durationInDays,
        uint amountToRaise
    ) external {
        uint raiseUntil = now.add(durationInDays.mul(1 days));
        campaign newcampaign = new campaign(msg.sender, title, description, raiseUntil, amountToRaise);
        campaigns.push(newcampaign);
        emit campaignStarted(
            address(newcampaign),
            msg.sender,
            title,
            description,
            raiseUntil,
            amountToRaise
        );
    }                                                                                                                                   
    
    function returnAllcampaigns() external view returns(campaign[] memory){
        return campaigns;
    }
}


contract campaign {
    using SafeMath for uint256;
    
    enum State {
        Fundraising,
        Expired,
        Successful
    }

    address payable public creator;
    uint public amountGoal; 
    uint public completeAt;
    uint256 public currentBalance;
    uint public raiseBy;
    string public title;
    string public description;
    State public state = State.Fundraising; 
    mapping (address => uint) public contributions;

    event FundingReceived(address contributor, uint amount, uint currentTotal);
    event CreatorPaid(address recipient);

    modifier inState(State _state) {
        require(state == _state);
        _;
    }

    modifier isCreator() {
        require(msg.sender == creator);
        _;
    }

    constructor
    (
        address payable campaignStarter,
        string memory campaignTitle,
        string memory campaignDesc,
        uint fundRaisingDeadline,
        uint goalAmount
    ) public {
        creator = campaignStarter;
        title = campaignTitle;
        description = campaignDesc;
        amountGoal = goalAmount;
        raiseBy = fundRaisingDeadline;
        currentBalance = 0;
    }

    function contribute() external inState(State.Fundraising) payable {
        require(msg.sender != creator);
        contributions[msg.sender] = contributions[msg.sender].add(msg.value);
        currentBalance = currentBalance.add(msg.value);
        emit FundingReceived(msg.sender, msg.value, currentBalance);
        checkIfFundingCompleteOrExpired();
    }

    function checkIfFundingCompleteOrExpired() public {
        if (currentBalance >= amountGoal) {
            state = State.Successful;
            payOut();
        } else if (now > raiseBy)  {
            state = State.Expired;
        }
        completeAt = now;
    }

    function payOut() internal inState(State.Successful) returns (bool) {
        uint256 totalRaised = currentBalance;
        currentBalance = 0;

        if (creator.send(totalRaised)) {
            emit CreatorPaid(creator);
            return true;
        } else {
            currentBalance = totalRaised;
            state = State.Successful;
        }

        return false;
    }
    
    function getDetails() public view returns 
    (
        address payable campaignStarter,
        string memory campaignTitle,
        string memory campaignDesc,
        uint256 deadline,
        State currentState,
        uint256 currentAmount,
        uint256 goalAmount
    ) {
        campaignStarter = creator;
        campaignTitle = title;
        campaignDesc = description;
        deadline = raiseBy;
        currentState = state;
        currentAmount = currentBalance;
        goalAmount = amountGoal;
    }
}
