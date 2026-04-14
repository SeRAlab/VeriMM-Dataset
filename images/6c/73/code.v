module top_module(
  input clk,
  input [7:0] a, 
  input [15:0] we, 
  input [15:0] d,
  output reg [15:0] q
);reg [15:0] mem[0:255];
  integer i;
  always @(posedge clk) begin
    for (i=0; i<16; i=i+1) begin
      if (we[i]) mem[a][i] <= d[i];
    end
  end
  always @(posedge clk) q <= mem[a];
endmodule