module twos_complement(
    input [3:0] in,
    output reg [3:0] out
);

    // Invert all bits of "in"
    wire [3:0] inverted = ~in;

    // Add 1 to the inverted value
    wire [3:0] added = inverted + 1;

    // Output the resulting value as "out"
    assign out = added;

endmodule