module top_module(
  input [3:0] bcd,
  output [7:0] bin
);// Convert BCD to decimal
  wire [3:0] decimal = bcd[3]*8 + bcd[2]*4 + bcd[1]*2 + bcd[0]*1;

  // Convert decimal to binary
  wire [7:0] binary;
  assign binary = {decimal[2], decimal[1], decimal[0]} << (decimal[3] ? 3 : 0);

  // Output binary code
  assign bin = binary;

endmodule