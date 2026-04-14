module top_module(A, Y);parameter OFFSET = 0;
parameter A_WIDTH = 0;
parameter Y_WIDTH = 0;

input [A_WIDTH-1:0] A;
output [Y_WIDTH-1:0] Y;

assign Y = A >> OFFSET;

endmodule