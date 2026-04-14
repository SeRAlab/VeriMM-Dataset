module top_module(q,d,clk);parameter BITS = 1; 
  input [BITS-1:0] d; 
  output reg [BITS-1:0] q; 
  input clk; 
  always @ (posedge clk) begin 
  q <= d; 
  end 
 endmodule