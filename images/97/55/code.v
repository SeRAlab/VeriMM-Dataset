module top_module( 
    input [2:0] a,
    input [2:0] b,
    output [2:0] out_and_bitwise,
    output out_and_logical,
    output [2:0] out_xor,
    output [5:0] out_not
);// Inverse of input a
    wire [2:0] a_inv = ~a;

    // Inverse of input b
    wire [2:0] b_inv = ~b;

    // Bitwise AND
    assign out_and_bitwise = a & b;

    // Logical AND
    assign out_and_logical = (a != 0) && (b != 0);

    // Bitwise XOR
    assign out_xor = a ^ b;

    // MUX to select between input and its inverse
    assign out_not[5:3] = a_inv;
    assign out_not[2:0] = b_inv;

endmodule