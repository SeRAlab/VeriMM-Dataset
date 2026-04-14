module top_module(
    input [3:0] in,
    output reg [3:0] out
);// Flip all bits in the input
wire [3:0] flipped_in = ~in;

// Add 1 to the flipped input
wire [3:0] one = 1;
wire [3:0] added_in = flipped_in + one;

// Assign the output to the added input
assign out = added_in;

endmodule