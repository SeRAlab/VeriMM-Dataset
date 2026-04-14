module top_module(B,bus,ldb,clk);input [15:0] bus;
  input ldb,clk;
  output reg [15:0] B;
  always@(posedge clk)
    if (ldb)
      B <= bus;endmodule