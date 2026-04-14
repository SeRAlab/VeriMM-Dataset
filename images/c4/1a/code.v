module four_bit_adder (
  input [3:0] A,
  input [3:0] B,
  input CIN,
  input CLK,
  output reg [3:0] S,
  output reg COUT
);

  always @(posedge CLK) begin
    // calculate sum
    S <= A + B + CIN;
    // calculate carry-out
    COUT <= (A[3] & B[3]) | (A[3] & CIN) | (B[3] & CIN);
  end

endmodule
