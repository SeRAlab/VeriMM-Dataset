module top_module(
    input [2:0] a,
    input [2:0] b,
    output [2:0] out_or_bitwise,
    output out_or_logical,
    output [5:0] out_not
);// Bitwise OR using XOR and inverter gates
    wire [2:0] xor_result;
    assign xor_result = a ^ b;
    assign out_or_bitwise = ~xor_result;

    // Logical OR using AND and OR gates
    wire [2:0] and_result;
    assign and_result = a & b;
    assign out_or_logical = |and_result;

    // NOT using inverter gates
    wire [2:0] not_a;
    wire [2:0] not_b;
    assign not_a = ~a;
    assign not_b = ~b;
    assign out_not = {not_a, not_b};

endmodule