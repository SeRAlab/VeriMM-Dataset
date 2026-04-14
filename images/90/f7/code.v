module xor_gate(
    input [15:0] a,
    input [15:0] b,
    output [15:0] result
);
    assign result = a ^ b;
endmodule