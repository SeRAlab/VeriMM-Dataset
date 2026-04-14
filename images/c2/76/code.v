module GrayCodeConverter (
  input [n-1:0] bin,
  output [n-1:0] gray
);

parameter n = 4; // number of bits in binary and Gray code

// Binary to Gray conversion
assign gray = bin ^ (bin >> 1);

// Gray to Binary conversion
assign bin = gray ^ (gray >> 1);

endmodule