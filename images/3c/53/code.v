module dot_product (
    input [7:0] A0, A1, A2, A3, A4,
    input [7:0] B0, B1, B2, B3, B4,
    output [15:0] product
);
    assign product = (A0 * B0) + (A1 * B1) + (A2 * B2) + (A3 * B3) + (A4 * B4);
endmodule