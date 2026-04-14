module top_module(CLK,RST,put,EN_put,RDY_put,get,EN_get,RDY_get,modReady,inverseReady);parameter DATA_WIDTH = 1; 
  input CLK; 
  input RST; 
  output [DATA_WIDTH-1 : 0] get; 
  input [DATA_WIDTH-1 : 0] put; 
  input EN_get; 
  input EN_put; 
  output RDY_get; 
  output RDY_put; 
  output modReady; 
  output inverseReady; 
  assign get = put; 
  assign RDY_get = 1; 
  assign RDY_put = 1; 
  assign modReady = EN_get; 
  assign inverseReady = EN_put; 
 endmodule