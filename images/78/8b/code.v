module top_module(o,oe);output [31:0] o; 
  assign o = 32'h12345679; 
  output [31:0] oe; 
  assign oe = 32'hab345679; 
 endmodule