module top_module(A, B, C, out);input [3:0] A, B;
input C;
output [3:0] out;

wire [3:0] sum;
wire [3:0] neg_b;

assign neg_b = ~B + 1;

// Adder
assign sum = A + B;

// Subtractor
assign diff = A + neg_b;

// Output selection
assign out = C ? diff : sum;

endmodule