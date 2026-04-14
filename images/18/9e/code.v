module multiplier32bit (
    input [31:0] a,      // First 32-bit input
    input [31:0] b,      // Second 32-bit input
    output [63:0] product // 64-bit output for the product
);
    assign product = a * b; // Combinational logic for multiplication
endmodule