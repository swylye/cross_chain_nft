// SPDX-License-Identifier: MIT

pragma solidity 0.8.4;
pragma abicoder v2;

import "./NonblockingLzApp.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract CrossChainNftDest is Ownable, ERC721Enumerable, NonblockingLzApp {
    mapping(uint256 => address) public tokenAvailableForClaim;

    event CrossChainSend(
        address initiator,
        uint256 tokenId,
        uint16 destinationChainId,
        address recipient
    );
    event CrossChainReceipt(
        address recipient,
        uint256 tokenId,
        uint16 sourceChainId
    );

    constructor(address _lzEndpoint)
        NonblockingLzApp(_lzEndpoint)
        ERC721("Cross Chain NFT", "CC-NFT")
    {}

    function claimToken(uint256 _tokenId) external {
        require(
            tokenAvailableForClaim[_tokenId] == msg.sender,
            "NOT_CLAIMABLE"
        );
        delete tokenAvailableForClaim[_tokenId];
        _mint(msg.sender, _tokenId);
    }

    function _nonblockingLzReceive(
        uint16 _srcChainId,
        bytes memory _srcAddress,
        uint64 _nonce,
        bytes memory _payload
    ) internal override {
        (bytes memory toAddressBytes, uint256 tokenId) = abi.decode(
            _payload,
            (bytes, uint256)
        );
        address toAddress;
        assembly {
            toAddress := mload(add(toAddressBytes, 20))
        }
        tokenAvailableForClaim[tokenId] = toAddress;
        emit CrossChainReceipt(toAddress, tokenId, _srcChainId);
    }

    function sendCrossChain(
        uint16 _dstChainId,
        bytes memory _toAddress,
        uint256 _tokenId
    ) public payable {
        bytes memory payload = abi.encode(_toAddress, _tokenId);
        _burn(_tokenId);
        _lzSend(
            _dstChainId,
            payload,
            payable(msg.sender),
            address(0x0),
            bytes("")
        );
        address toAddress;
        assembly {
            toAddress := mload(add(_toAddress, 20))
        }
        emit CrossChainSend(msg.sender, _tokenId, _dstChainId, toAddress);
    }
}
