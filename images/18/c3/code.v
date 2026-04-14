module xor_hash (
    input [3:0] a,
    input [3:0] b,
    output [3:0] hash
);
    assign hash = a ^ b; // XOR operation for hash generation
endmodule