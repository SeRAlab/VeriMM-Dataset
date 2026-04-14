module top_module(
  input signed [7:0] A,
  input signed [7:0] B,
  output reg signed [15:0] C
);always @(A or B) begin
    C = A * B;
  end

endmodule