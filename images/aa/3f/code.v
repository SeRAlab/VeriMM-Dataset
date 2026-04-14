module top_module(clk, d, a, q);input clk; 
  input [3:0] d; 
  input [1:0] a; 
  output [3:0] q; 
  reg [3:0] ram[3:0]; 
  reg [3:0] q; 
  always @(d or a) begin 
  q <= ram[a]; 
  ram[a] <= d; 
  end 
 endmodule