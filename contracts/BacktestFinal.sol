pragma solidity ^0.4.18;

contract BacktestFinal {

    bytes15 public name;


    struct StrategyExplicitexplicitState {
      uint64 date;
      int8 position;
      int256 variation;
      uint64 price;
      int8 category;
    }

    StrategyExplicitexplicitState explicitState;

    event newRecord(bytes15 indexed name, uint64 indexed date, int256 stratVariation, uint64 stratPrice, uint64 underPrice, int8 position,int8 category);
    function BacktestFinal(){
        name = "Multi 1.0";
        explicitState.price =100000000000000;
    }
    // that backtesting function requires that the strategy explicitState be at the date matching
    // the beginning of the array date
    function batchbacktest(uint64[]dates, uint64[] prices, int8[] positions) public {
      uint batchlength = positions.length;
      require(dates.length==batchlength && prices.length==batchlength);

      uint64 strategyInitPrice = explicitState.price;

      uint64 strategyPrice = libbatchbacktest(name,strategyInitPrice,dates,prices,positions);

      explicitState.position = positions[batchlength-1];
      explicitState.date = dates[batchlength-1];
      explicitState.price = strategyPrice;
  	}

    function libbatchbacktest(bytes15 name, uint64 strategyInitPrice, uint64[]dates, uint64[] prices, int8[] positions) public returns (uint64) {
         uint64 strategyPrice = strategyInitPrice;

         for(uint8 i=1; i<dates.length; i++){

             int256 variation = calVariation(prices[i-1], prices[i], positions[i-1]);
             strategyPrice = calValue(variation, strategyPrice);

             emit newRecord(name,dates[i],variation, strategyPrice, prices[i], positions[i],0);
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
  function calVariation(uint64 pxPre, uint64 pxCur, int8 lastPosit) internal returns (int256 ){
     int256 variation;
     if(lastPosit==0){
         variation = 0;
     }
     else{
         variation = int256(pxCur) - int256(pxPre);
         variation *= 1e32;
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
  function calValue(int256 variation, uint64 lastValue) internal returns (uint64){
     if(variation==0) return lastValue;
     else {
         int256 delta = int256(lastValue) * variation;
         delta/=1e32;
         return uint64(int256(lastValue) +delta);
     }
  }

}
