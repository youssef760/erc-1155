// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

// Uncomment this line to use console.log
// import "hardhat/console.sol";

contract ERC1155 {

    event TransferSingle(address indexed _operator, address indexed _from, address indexed _to, uint _id, uint _value);
    event TransferBatch(address _operator, address _from, address _to, uint[] _ids, uint[] _values);
    event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
    // event URI()
    mapping(uint => mapping(address => uint)) internal _balances;
    mapping(address => mapping(address => bool)) private _operatorApprovals;
    // Gets the balance of an accounts tokens
    function balanceOf(address account, uint id) public view returns(uint) {
        require(account != address(0), "Address is zero");
        return _balances[id][account];
    }
    
    // Gets the balance of an accounts tokens

    function balanceOfBatch(
        address[] memory accounts, 
        uint[] memory ids
    ) public view returns(uint[] memory) {
        require(accounts.length == ids.length, 'Accounts and ids are not the same length');
        uint[] memory batchBalances = new uint[] (accounts.length);

        for (uint256 i = 0; i < accounts.length; i++) {
            batchBalances[i] = balanceOf(accounts[i], ids[i]);
        }

        return batchBalances;
    }
    
    // Checks if an address is an operator for another address
    function isApprovedForAll(address account, address operator) public view returns (bool) {
        return _operatorApprovals[account][operator];
    }

    // Enables or disable an operaor to manage all of msg.senders assets
    function setApprovalForAll(address operator, bool approved) public {
        _operatorApprovals[msg.sender][operator] = approved;
        emit ApprovalForAll(msg.sender, operator, approved);
    }

    function _transfer(address from, address to, uint id, uint amount) private {
        uint fromBalance = _balances[id][from];
        require(fromBalance >= amount, 'Insufficient balance');
        _balances[id][from] = fromBalance - amount;
        _balances[id][to] += amount;
    }
    
    function safeTransferFrom(
        address from, 
        address to, 
        uint id, 
        uint amount
    ) public virtual {
        require(from == msg.sender || isApprovedForAll(from, msg.sender), "Msg.sender is not the owner or approved for transfer");
        require(to != address(0), 'Address is 0');
        _transfer(from, to, id, amount);
        emit TransferSingle(msg.sender, from, to, id, amount);

        require(_checkOnERC1155Received(), 'Receiver is not implemented');
    }

    

    function safeBatchTransferFrom(
        address from, 
        address to, 
        uint[] memory ids, 
        uint[] memory amounts 
    ) public {
        require(from == msg.sender || isApprovedForAll(from, msg.sender), "Msg.sender is not the owner or approved for transfer");
        require(to != address(0), 'Address is 0');
        require(amounts.length == ids.length, 'Accounts and ids are not the same length');
        for (uint i = 0; i <= ids.length; i++) {
            uint id = ids[i];
            uint amount = amounts[i];

            _transfer(from, to, id, amount);
        }

        emit TransferBatch(msg.sender, from, to, ids, amounts);
        require(_checkOnERC1155Received(), 'Receiver is not implemented');
    }

    function _checkOnERC1155Received() private pure returns(bool) {
        return true;
    }

    // ERC165 Compliant
    // interfaceId == 0xd9b67a26 
    function supportsInterface(bytes4 interfaceId) public pure returns(bool) {
        return interfaceId == 0xd9b67a26;
    }

}
