module top_module(CLK,RST,put,EN_put,RDY_put,get,EN_get,RDY_get);parameter DATA_WIDTH = 1; 
  input CLK; 
  input RST; 
  output [DATA_WIDTH-1 : 0] get; 
  input [DATA_WIDTH-1 : 0] put; 
  input EN_get; 
  input EN_put; 
  output RDY_get; 
  output RDY_put; 
  assign get = put; 
  assign RDY_get = EN_put; 
  assign RDY_put = EN_get; 
 endmodule