module top_module(
  input clk,
  input [7:0] a, 
  input [1:0] we, 
  input [15:0] d,
  output reg [15:0] q
);reg [15:0] mem[0:255];
  always @(posedge clk) begin
    if (we[0]) mem[a][7:0] <= d[7:0];
    if (we[1]) mem[a][15:8] <= d[15:8];
  end
  always @(posedge clk) q <= mem[a];
endmodule