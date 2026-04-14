module top_module(
  input [3:0] abcd,
  output [1:0] xy
);// Simplified logic expressions using Karnaugh maps
wire x = abcd[2] ^ abcd[3];
wire y = (~abcd[2] & abcd[1]) | (abcd[0] & ~abcd[1]);

// Output assignments
assign xy[0] = x;
assign xy[1] = y;

endmodule