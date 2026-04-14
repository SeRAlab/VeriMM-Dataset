module top_module( clk, ld, d, q );input clk; 
  input ld; 
  input [63:0] d; 
  output [63:0] q; 
  reg [63:0] q; 
 `ifdef RANDOM_INIT 
  initial 
  $random_init("q"); 
 `endif 
  always @(posedge clk) begin 
  if (ld) 
  q <= d; 
  end 
 endmodule