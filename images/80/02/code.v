module top_module(
    input [3:0] A,
    input [3:0] B,
    input SUB,
    output [3:0] OUT,
    output COUT
);wire [3:0] B_INV;
wire [3:0] ADD;
wire SUB_NEG;

// Invert B
assign B_INV = ~B;

// Add 1 to inverted B to perform subtraction
assign B_INV = B_INV + 1;

// Perform addition or subtraction based on SUB input
assign ADD = SUB ? A + B_INV : A + B;

// Determine if output is negative
assign SUB_NEG = ADD[3];

// Set COUT based on sign bit
assign COUT = SUB_NEG;

// Output result
assign OUT = ADD;

endmodule