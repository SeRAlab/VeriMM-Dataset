module top_module(
  input clk,
  input reset,
  input [15:0] A,
  input [15:0] B,
  output [15:0] C
);reg [15:0] sum;

  always @(posedge clk) begin
    if (reset) begin
      sum <= 16'b0;
    end else begin
      sum <= A + B;
    end
  end

  assign C = sum;

endmodule