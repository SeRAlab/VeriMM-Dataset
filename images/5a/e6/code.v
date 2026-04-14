module top_module( 
    input [2:0] a,
    input [2:0] b,
    output out_xor,
    output [2:0] out_and_bitwise,
    output [2:0] out_xor_bitwise,
    output [2:0] out_nor_bitwise,
    output [5:0] out_not
);wire [2:0] a_not;
    wire [2:0] b_not;
    wire [2:0] and_bitwise;
    wire [2:0] xor_bitwise;
    wire [2:0] nor_bitwise;

    assign a_not = ~a;
    assign b_not = ~b;
    assign and_bitwise = a & b;
    assign xor_bitwise = a ^ b;
    assign nor_bitwise = ~(a | b);

    assign out_xor = a ^ b;
    assign out_and_bitwise = and_bitwise;
    assign out_xor_bitwise = xor_bitwise;
    assign out_nor_bitwise = nor_bitwise;
    assign out_not = {b_not, a_not};

endmodule