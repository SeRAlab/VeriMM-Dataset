module twos_complement(
    input [3:0] in,
    output [3:0] out
);

wire [3:0] inv;
wire [3:0] add_one;

// invert all bits of input
assign inv = ~in;

// add 1 to inverted input
assign add_one = inv + 4'b0001;

// assign result to output
assign out = add_one;

endmodule