module array_multiplier (
    input [3:0] A,
    input [3:0] B,
    output [7:0] P
);
    wire [3:0] partial_product[3:0];
    
    assign partial_product[0] = A & {4{B[0]}};
    assign partial_product[1] = A & {4{B[1]}} << 1;
    assign partial_product[2] = A & {4{B[2]}} << 2;
    assign partial_product[3] = A & {4{B[3]}} << 3;

    assign P = partial_product[0] + partial_product[1] + partial_product[2] + partial_product[3];
endmodule