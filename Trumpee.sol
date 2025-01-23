// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.22;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {ERC20Burnable} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import {ERC20Permit} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";
import {ERC20Votes} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Votes.sol";
import {Nonces} from "@openzeppelin/contracts/utils/Nonces.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract Trumpee is ERC20, ERC20Burnable, ERC20Permit, ERC20Votes, Ownable {
    address private _deployer;

    constructor(address initialOwner)
        ERC20("Trumpee", "Tmp")
        ERC20Permit("Trumpee")
        Ownable(initialOwner)
    {
        _deployer = initialOwner;
        _mint(msg.sender, 1000000000 * 10 ** decimals());
    }

    // Modifier to restrict burn function to the deployer
    modifier onlyDeployer() {
        require(msg.sender == _deployer, "Trumpee: Only the deployer can burn tokens");
        _;
    }

    // Override burn function to add deployer restriction
    function burn(uint256 amount) public override onlyDeployer {
        super.burn(amount);
    }

    /**
     * @dev Permet au propriétaire de distribuer des tokens à plusieurs adresses en une seule transaction.
     * @param recipients La liste des adresses recevant les tokens.
     * @param amounts La liste des montants correspondants à distribuer.
     */
    function airdrop(address[] calldata recipients, uint256[] calldata amounts) external onlyOwner {
        require(recipients.length == amounts.length, "Trumpee: Recipients and amounts length mismatch");

        for (uint256 i = 0; i < recipients.length; i++) {
            _transfer(msg.sender, recipients[i], amounts[i]);
        }
    }

    // The following functions are overrides required by Solidity.

    function _update(address from, address to, uint256 value)
        internal
        override(ERC20, ERC20Votes)
    {
        super._update(from, to, value);
    }

    function nonces(address owner)
        public
        view
        override(ERC20Permit, Nonces)
        returns (uint256)
    {
        return super.nonces(owner);
    }
}
