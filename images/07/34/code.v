module multiplier_16bit (
    input [15:0] a,
    input [15:0] b,
    output [31:0] product
);
    assign product = a * b; // Combinational multiplication
endmodule