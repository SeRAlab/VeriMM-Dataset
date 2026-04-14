module array_multiplier (
    input [3:0] a, // 4-bit input
    input [3:0] b, // 4-bit input
    output [7:0] product // 8-bit output
);
    wire [3:0] partial [3:0]; // partial products

    // Generate partial products
    assign partial[0] = a & {4{b[0]}};
    assign partial[1] = a & {4{b[1]}};
    assign partial[2] = a & {4{b[2]}};
    assign partial[3] = a & {4{b[3]}};

    // Shift partial products and sum them up
    assign product = {partial[3], 1'b0} + 
                     {partial[2], 2'b00} + 
                     {partial[1], 3'b000} + 
                     {partial[0], 4'b0000};
endmodule