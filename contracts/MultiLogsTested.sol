pragma solidity ^0.4.18;

contract MultiLogsTested {

    bytes15 public name;

    struct StrategyExplicitexplicitState {
      uint32 date;
      int8 position;
      int48 variation;
      uint48 price;
      int8 category;
    }

    StrategyExplicitexplicitState explicitState;

    event newRecord(bytes15 indexed name, uint32 indexed date, int256 stratVariation, uint48 stratPrice, int8 position,int8 category);

    function MultiLogsTested(){
        name = "Multi 1.0";
        explicitState.price =100000000;
    }
    // that backtesting function requires that the strategy explicitState be at the date matching
    // the beginning of the array date
    function batchbacktest(uint32[]dates, uint32[] prices, int8[] positions) public {
      uint batchlength = positions.length;
      require(dates.length==batchlength && prices.length==batchlength);

      uint48 strategyInitPrice = explicitState.price;

      uint48 strategyPrice = libbatchbacktest(name,strategyInitPrice,dates,prices,positions);

      explicitState.position = positions[batchlength-1];
      explicitState.date = dates[batchlength-1];
      explicitState.price = strategyPrice;
  	}

    function libbatchbacktest(bytes15 name, uint48 strategyInitPrice, uint32[]dates, uint32[] prices, int8[] positions) public returns (uint48) {
         uint48 strategyPrice = strategyInitPrice;

         for(uint8 i=1; i<dates.length; i++){

             int256 variation = calVariation(prices[i-1], prices[i], positions[i-1]);
             strategyPrice = calValue(variation, strategyPrice);

             emit newRecord(name,dates[i],variation, strategyPrice, positions[i],0);
         }
         return strategyPrice;
   }

   /*------------------------------------------------------------------------
Compute the variation of price of index according to the last position EOD
----Arguments:
       pxPre : price of precedent open dat
       pxCur : price EOD
       lastPosit : last position EOD
----Return:
       (pxCur/pxPre)^(lastPosit)-1
-------------------------------------------------------------------------*/
  function calVariation(uint32 pxPre, uint32 pxCur, int8 lastPosit) internal returns (int256 ){
     int256 variation;
     if(lastPosit==0){
         variation = 0;
     }
     else{
         variation = int256(pxCur) - int256(pxPre);
         variation *= 1e64;
         variation /=  pxPre;
         if(lastPosit==-1){
             variation *=-1;
         }
     }
     return variation;
  }

  /*------------------------------------------------------------------------
  Compute the algo value EOD for some index
  ----Arguments:
     variation : the variation of algo index value
     lastValue : last algo value EOD
  ----Return :
     lastValue*(1+variation)
  --------------------------------------------------------------------------*/
  function calValue(int256 variation, uint48 lastValue) internal returns (uint48){
     if(variation==0) return lastValue;
     else {
         int256 delta = int256(lastValue) * variation;
         delta/=1e64;
         return uint48(int256(lastValue) +delta);
     }
  }

}
