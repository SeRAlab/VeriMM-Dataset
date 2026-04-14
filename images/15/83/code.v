module multiplier_16x16 (
    input [15:0] a,
    input [15:0] b,
    output [31:0] product
);
    assign product = a * b; // Combinational logic for multiplication
endmodule