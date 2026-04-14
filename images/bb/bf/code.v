module top_module(
  input [3:0] A,
  input [3:0] B,
  output reg [3:0] S,
  output reg C_out
);reg [3:0] carry;
  integer i;

  always @(*) begin
    carry[0] = 1'b0; // Initial carry-in
    for (i = 0; i < 4; i = i + 1) begin
      {carry[i+1], S[i]} = A[i] + B[i] + carry[i]; // Full adder operation
    end
    C_out = carry[4]; // Final carry-out
  end
  
endmodule