module xor_module(
    input [3:0] a,
    output [3:0] b
);

    // Define constant value
    parameter [3:0] c = 4'b1011;

    // Perform XOR operation between a and c
    assign b = a ^ c;

endmodule