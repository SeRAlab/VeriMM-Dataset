module top_module(
  input [3:0] A,
  input [3:0] B,
  input sub,
  input clk,
  input rst,
  output [3:0] out,
  output cout
);reg [3:0] A_inv;
  reg [3:0] B_inv;
  reg [3:0] sum;
  reg carry;

  // Invert B if subtracting
  assign B_inv = sub ? ~B + 1 : B;

  // Invert A if subtracting
  assign A_inv = sub ? ~A : A;

  // Full adder
  always @(posedge clk) begin
    if (rst) begin
      sum <= 0;
      carry <= 0;
    end else begin
      {carry, sum} <= A_inv + B_inv + carry;
    end
  end

  // Output
  assign out = sum;
  assign cout = carry;

endmodule