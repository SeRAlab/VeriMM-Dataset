module top_module(
  input signed [7:0] A,
  input signed [7:0] B,
  output reg signed [7:0] sum,
  output reg signed [7:0] diff,
  output reg signed [15:0] product,
  output reg signed [7:0] quotient
);always @ (A or B) begin
    sum = A + B;
    diff = A - B;
    product = A * B;
    if (B == 0) begin
      quotient = 0;
    end else begin
      quotient = A / B;
    end
  end

endmodule