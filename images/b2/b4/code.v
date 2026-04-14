module top_module(q,clk, rst_l, d);parameter WIDTH = 1; 
  parameter RESET = {WIDTH{1'b0}}; 
  parameter RESET_WIDTH = WIDTH; 
  input clk; 
  input rst_l; 
  input [WIDTH-1:0] d; 
  output reg [WIDTH-1:0] q; 
  always_ff @(posedge clk or negedge rst_l) begin 
  if ($bits(RESET) != RESET_WIDTH) $stop; 
  if (~rst_l) q <= RESET; 
  else q <= d; 
  end 
 endmodule