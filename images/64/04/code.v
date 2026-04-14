module top_module(SW, LEDR);input [2:0] SW;
output [5:0] LEDR;

wire a, b, c;

assign a = SW[2];
assign b = SW[1];
assign c = SW[0];

assign LEDR[5] = a & b;
assign LEDR[4] = (a & b & c) | (a & ~b);
assign LEDR[3] = c;
assign LEDR[2] = b & ~c;
assign LEDR[1] = 0;
assign LEDR[0] = c;
endmodule