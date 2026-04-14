module top_module(
  input [n-1:0] a,
  input [n-1:0] b,
  input [1:0] ctrl,
  output reg out // Change output to reg to allow assignment in always block
);parameter n = 8; // number of bits in input numbers

reg signed [n:0] a_signed, b_signed; // Change array width to n:0 for correct sign extension

// Sign extension for signed numbers
always @(*) begin
  if (ctrl == 2'b01 || ctrl == 2'b10) begin // Handle both cases in the same block
    a_signed = {a[n-1], a}; // Sign-extend a
    b_signed = {b[n-1], b}; // Sign-extend b
  end
end

// Comparison logic
always @(*) begin
  case (ctrl)
    2'b00: out = (a == b);
    2'b01: out = (a_signed > b_signed);
    2'b10: out = (a_signed < b_signed);
    default: out = 1'b0;
  endcase
end

endmodule