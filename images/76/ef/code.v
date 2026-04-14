module top_module(
  input [3:0] in,
  output [6:0] led
);parameter n = 4; // number of input bits

// Truth table for each segment
// a b c d e f g
// 0 0 0 0 0 0 1 -> 0
// 1 0 0 1 1 1 1 -> 1
// 0 0 1 0 0 1 0 -> 2
// 0 0 0 0 1 1 0 -> 3
// 1 0 0 1 1 0 0 -> 4
// 0 1 0 0 1 0 0 -> 5
// 0 1 0 0 0 0 0 -> 6
// 0 0 0 1 1 1 1 -> 7
// 0 0 0 0 0 0 0 -> 8
// 0 0 0 1 1 0 0 -> 9

// Define Boolean functions for each segment
wire a = (in == 4'b0000) || (in == 4'b0010) || (in == 4'b0100) || (in == 4'b0111) || (in == 4'b1000) || (in == 4'b1001) || (in == 4'b1010) || (in == 4'b1100) || (in == 4'b1101) || (in == 4'b1110);
wire b = (in == 4'b0000) || (in == 4'b0001) || (in == 4'b0011) || (in == 4'b0111) || (in == 4'b1001) || (in == 4'b1010) || (in == 4'b1100) || (in == 4'b1101) || (in == 4'b1110) || (in == 4'b1111);
wire c = (in == 4'b0000) || (in == 4'b0001) || (in == 4'b0100) || (in == 4'b0101) || (in == 4'b0111) || (in == 4'b1000) || (in == 4'b1011) || (in == 4'b1100) || (in == 4'b1101) || (in == 4'b1111);
wire d = (in == 4'b0000) || (in == 4'b0001) || (in == 4'b0010) || (in == 4'b0100) || (in == 4'b1000) || (in == 4'b1011) || (in == 4'b1100) || (in == 4'b1101) || (in == 4'b1110) || (in == 4'b1111);
wire e = (in == 4'b0000) || (in == 4'b0001) || (in == 4'b0010) || (in == 4'b0100) || (in == 4'b1000) || (in == 4'b1010) || (in == 4'b1011) || (in == 4'b1100) || (in == 4'b1101) || (in == 4'b1111);
wire f = (in == 4'b0000) || (in == 4'b0010) || (in == 4'b0100) || (in == 4'b0101) || (in == 4'b0111) || (in == 4'b1000) || (in == 4'b1011) || (in == 4'b1100) || (in == 4'b1101) || (in == 4'b1111);
wire g = (in == 4'b0000) || (in == 4'b0001) || (in == 4'b0010) || (in == 4'b0100) || (in == 4'b0111) || (in == 4'b1000) || (in == 4'b1001) || (in == 4'b1010) || (in == 4'b1100) || (in == 4'b1111);

// Connect input signals to LED segments
assign led[0] = a;
assign led[1] = b;
assign led[2] = c;
assign led[3] = d;
assign led[4] = e;
assign led[5] = f;
assign led[6] = g;

endmodule