module top_module(A,bus,lda,clk);input [15:0] bus;
  input lda,clk;
  output reg [15:0] A;
  always@(posedge clk)
    if (lda)
      A <= bus;endmodule