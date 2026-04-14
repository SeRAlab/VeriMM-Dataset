module top_module(
  input [31:0] in,
  input [4:0] shift_amt,
  input [1:0] mode,
  output [31:0] out
);wire [31:0] shifted_value;

  // Combine the shifting operation based on mode
  assign shifted_value = (mode == 2'b00) ? (in >> shift_amt) :  // Logical right shift
                         (mode == 2'b01) ? (in >>> shift_amt) : // Arithmetic right shift
                         (mode == 2'b10) ? (in << shift_amt) :  // Left shift
                         32'b0;   // Default case (should not happen)

  assign out = shifted_value;

endmodule