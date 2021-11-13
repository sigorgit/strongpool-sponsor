pragma solidity ^0.5.6;

interface IStrongPoolSponsor {

    event SendIJM(address indexed user, uint256 amount);
    event SendKlay(address indexed user, uint256 amount);

    function sendIJM(uint256 amount) external;
    function ijmSponsorCount() external returns (uint256 count);
    function ijmSponsor(uint256 index) external returns (address addr, uint256 amount);

    function sendKlay() payable external;
    function klaySponsorCount() external returns (uint256 count);
    function klaySponsor(uint256 index) external returns (address addr, uint256 amount);
}
