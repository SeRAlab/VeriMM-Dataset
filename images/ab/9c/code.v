module top_module(
  input clk, rst,
  input [7:0] A, B,
  output reg [8:0] C
);always @(posedge clk) begin
    if (rst) begin
      C <= 0;
    end else begin
      C <= A + B;
      if (C > 255) begin
        C <= C - 256;
        C[8] <= 1;
      end else begin
        C[8] <= 0;
      end
    end
  end

endmodule