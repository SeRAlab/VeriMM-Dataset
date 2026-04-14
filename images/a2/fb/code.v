module top_module(
  input [31:0] in,
  input [4:0] shift,
  output [31:0] out
);// Create a temporary wire to hold the shifted input
  wire [31:0] shifted_input;

  // Perform the right shift operation
  assign shifted_input = in >> shift;

  // Fill the shifted-in bits with zeros
  assign out = shifted_input & ((1 << 32) - (1 << shift));

endmodule