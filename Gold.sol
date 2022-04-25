// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v3.2.0-solc-0.7/contracts/token/ERC20/ERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v3.2.0-solc-0.7/contracts/token/ERC20/ERC20Burnable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v3.2.0-solc-0.7/contracts/access/Ownable.sol";

contract BADtoken is ERC20Burnable, Ownable {

    mapping(address => bool) _blacklist;
    
    event BlacklistUpdated(address indexed user, bool value);

    constructor()
        ERC20("Gold Token", "GLD")
        Ownable()
    {
        // _owner = _msgSender();
        _mint(msg.sender, 10000000 * (10 ** uint256(decimals())));
    }
    
    function mint(address to, uint256 amount) public virtual onlyOwner {
        // require(_owner == _msgSender(), "Only owner is allowed to mint token.");
        _mint(to, amount);
    }
    
    function blacklistUpdate(address user, bool value) public virtual onlyOwner {
        // require(_owner == _msgSender(), "Only owner is allowed to modify blacklist.");
        _blacklist[user] = value;
        emit BlacklistUpdated(user, value);
    }
    
    function isBlackListed(address user) public view returns (bool) {
        return _blacklist[user];
    }
    
function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override(ERC20) {
        require (!isBlackListed(to), "Token transfer refused. Receiver is on blacklist");
        require (!isBlackListed(from), "Token transfer refused. You are on blacklist");
        super._beforeTokenTransfer(from, to, amount);
    }


}
