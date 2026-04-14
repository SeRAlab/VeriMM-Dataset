module xor_gate(
    input [3:0] a,
    input [3:0] b,
    output [3:0] y
);

    assign y = a ^ b;

endmodule