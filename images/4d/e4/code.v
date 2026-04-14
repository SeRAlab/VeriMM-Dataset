module top_module(
  input [n-1:0] a,
  input [n-1:0] b,
  input ctrl,
  output signed [2*n-1:0] res
);parameter n = 8; // number of bits in each input number

wire [2*n-1:0] unsigned_res;
wire signed [2*n-1:0] signed_res;

// Unsigned multiplication
assign unsigned_res = a * b; // Corrected assignment for unsigned multiplication

// Signed multiplication
assign signed_res = $signed(a) * $signed(b); // Corrected usage of $signed

// Select output based on control signal
assign res = (ctrl == 1) ? signed_res : unsigned_res;

endmodule