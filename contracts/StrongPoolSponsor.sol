pragma solidity ^0.5.6;

import "./klaytn-contracts/ownership/Ownable.sol";
import "./klaytn-contracts/math/SafeMath.sol";
import "./interfaces/IStrongPoolSponsor.sol";
import "./interfaces/IInjeolmi.sol";

contract StrongPoolSponsor is Ownable, IStrongPoolSponsor {
    using SafeMath for uint256;

    IInjeolmi public ijm;

    struct Sponsor {
        address addr;
        uint256 amount;
    }

    Sponsor[] public ijmSponsors;
    mapping(address => uint256) public ijmSponsorsIndex;

    Sponsor[] public klaySponsors;
    mapping(address => uint256) public klaySponsorsIndex;

    constructor(IInjeolmi _ijm) public {
        ijm = _ijm;
    }

    function addIJMSponsor(address addr, uint256 amount) onlyOwner public {
        Sponsor storage sponsor = ijmSponsors[ijmSponsorsIndex[addr]];
        if (sponsor.addr == addr) {
            sponsor.amount = sponsor.amount.add(amount);
        } else {
            uint256 index = ijmSponsors.length;
            ijmSponsors.push(Sponsor({
                addr: addr,
                amount: amount
            }));
            ijmSponsorsIndex[addr] = index;
        }
        emit SendIJM(addr, amount);
    }

    function addKlaySponsor(address addr, uint256 amount) onlyOwner public {
        Sponsor storage sponsor = klaySponsors[klaySponsorsIndex[addr]];
        if (sponsor.addr == addr) {
            sponsor.amount = sponsor.amount.add(amount);
        } else {
            uint256 index = klaySponsors.length;
            klaySponsors.push(Sponsor({
                addr: addr,
                amount: amount
            }));
            klaySponsorsIndex[addr] = index;
        }
        emit SendKlay(addr, amount);
    }

    function sendIJM(uint256 amount) external {
        ijm.transferFrom(msg.sender, address(this), amount);
        addIJMSponsor(msg.sender, amount.mul(9).div(10));
    }

    function ijmSponsorCount() external returns (uint256 count) {
        return ijmSponsors.length;
    }

    function ijmSponsor(uint256 index) external returns (address addr, uint256 amount) {
        Sponsor memory sponsor = ijmSponsors[index];
        (addr, amount) = (sponsor.addr, sponsor.amount);
    }

    function sendKlay() payable external {
        addKlaySponsor(msg.sender, msg.value);
    }

    function klaySponsorCount() external returns (uint256 count) {
        return klaySponsors.length;
    }

    function klaySponsor(uint256 index) external returns (address addr, uint256 amount) {
        Sponsor memory sponsor = klaySponsors[index];
        (addr, amount) = (sponsor.addr, sponsor.amount);
    }

    function sendToStrongPool(address _strongPool) onlyOwner external {
        address payable strongPool = address(uint160(_strongPool));
        strongPool.transfer(address(this).balance);
    }
}
