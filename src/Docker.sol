// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract Docker is Ownable {
    address public immutable harber;
    address public immutable origin;
    address public immutable backup;
    address public immutable backup2;

    event Withdraw(
        address sender,
        address to,
        uint256 amount,
        bool success,
        bytes data
    );

    event Received(
        address sender,
        address to,
        uint256 amount,
        bool redirect,
        bytes data
    );

    constructor(
        address _harber,
        address _origin,
        address _backup,
        address _backup2
    ) Ownable(_harber) {
        harber = _harber;
        origin = _origin;
        backup = _backup;
        backup2 = _backup2;
    }

    // only owner
    function withdrawBalance(address to) external onlyOwner {
        require(
            to == origin || to == backup || to == backup2,
            "Funds can only be withdraw to origin, backup or backup2"
        );
        (bool sent, bytes memory data) = to.call{value: address(this).balance}(
            ""
        );
        emit Withdraw(msg.sender, to, address(this).balance, sent, data);
    }

    fallback() external payable {}

    receive() external payable {
        (bool sent, bytes memory data) = harber.call{value: msg.value}("");
        emit Received(msg.sender, harber, msg.value, sent, data);
    }
}
