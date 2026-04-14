module top_module( clk, ld, d, q );input clk; 
  input d; 
  input ld; 
  output q; 
  reg q; 
 `ifdef RANDOM_INIT 
  initial 
  $random_init("q"); 
 `endif 
  always @(posedge clk) begin 
  if (ld) 
  q <= d; 
  end 
 endmodule