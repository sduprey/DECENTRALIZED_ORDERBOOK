pragma solidity ^0.4.18;


import './ERC20.sol';
import "./SlotManager.sol";

contract DecentralizedOrderBook{

    mapping (uint => address) private slotsMap;
    ERC20 token;
    mapping (address => uint) private cashBalance;
    mapping (address => uint) private withdrawAllowance;

    uint bestBid;
    uint bestAsk;

    function DecentralizedOrderBook(ERC20 _token){
        token = _token;
    }

    function settleCash(address _from, address _to, uint _quantity, uint _price){
        cashBalance[_from] -= _quantity*_price;
        withdrawAllowance[_to] += _quantity*_price;
    }

    function settleToken(address _from, address _to, uint _quantity){
        token.transferFrom(_from,_to,_quantity);
    }

    function handleAskRippingOrder(uint _quantity, uint _price, bool _direction, address proposer){
        for (uint localPrice = bestAsk; localPrice <= _price; localPrice++){
            address slotManagerAddress = slotsMap[_price];
            if (slotManagerAddress==address(0)){
                continue;
            }
            // the slot manager for this price is found
            SlotManager slotManager = SlotManager(slotManagerAddress);
            slotManager.handleSlotOrder(_quantity,_price,_direction,proposer);
        }
    }

    function handleBidRippingOrder(uint _quantity, uint _price, bool _direction, address proposer){
        // _price order lower than bestBid : we sell to the first bid levels
        for (uint localPrice=bestBid;localPrice>=_price;localPrice--){
            address slotManagerAddress = slotsMap[localPrice];
            if (slotManagerAddress==address(0)){
                continue;
            }
            // the slot manager for this price is found
            SlotManager slotManager = SlotManager(slotManagerAddress);
            slotManager.handleSlotOrder(_quantity,_price,_direction,proposer);
        }
    }

    function handleInsideSpreadOrder(uint _quantity, uint _price, bool _direction, address proposer){
        address slotManagerAddress = slotsMap[_price];
        if (slotManagerAddress==address(0)){
            slotManagerAddress = new SlotManager(this,token,_price);
            slotsMap[_price] = slotManagerAddress;
        }
        // the slot manager for this price is found
        SlotManager slotManager = SlotManager(slotManagerAddress);
        slotManager.handleSlotOrder(_quantity,_price,_direction,proposer);
    }

    function deleteOrder(uint _quantity, uint _price, bool _direction) public {
        address slotManagerAddress = slotsMap[_price];
        assert(slotManagerAddress!=address(0));
        // the slot manager for this price is found
        SlotManager slotManager = SlotManager(slotManagerAddress);
        slotManager.handleSlotDeleteOrder(_quantity,_price,_direction,msg.sender);
    }

    function handleOrder(uint _quantity, uint _price, bool _direction) public payable {
        // we here make sure that the incoming order is appropriate
        // if the incoming order wants to buy : it must bring cash with it
        if (_direction){
            assert(msg.value > _quantity*_price);
            cashBalance[msg.sender] += msg.value;
        } else {
            // if the incoming order wants to sell : it must have enough token
            // and delegate them to the spender : this contract
            assert(token.allowance(msg.sender,this) > 0);
        }

        // we here handle the best bid, best ask
        if (_direction){
            // the order is a bidding order
            if (_price > bestBid && _price < bestAsk){
                bestBid = _price;
                handleInsideSpreadOrder(_quantity,_price,_direction, msg.sender);
            } else {
                // the bidding order will rip off the first ask levels
                handleAskRippingOrder(_quantity,_price,_direction, msg.sender);
            }
        } else {
            // the order is an asking order
            if (_price < bestAsk && _price > bestBid){
                bestAsk = _price;
                handleInsideSpreadOrder(_quantity,_price,_direction, msg.sender);
            } else {
                // the asking order will rip off the first bid levels
                handleBidRippingOrder(_quantity,_price,_direction, msg.sender);
            }
        }
    }
}
