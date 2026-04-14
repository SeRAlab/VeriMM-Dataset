module top_module(output [(10 - 1):0] op,input clk,input ce,input clr);localparam [(10 - 1):0] const_value = 10'b0000000010; 
  assign op = 10'b0000000010; 
 endmodule