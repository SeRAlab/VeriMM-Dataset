module xor4(
    input [3:0] A,
    input [3:0] B,
    output [3:0] X
);

genvar i;
generate
    for (i = 0; i < 4; i = i + 1) begin : XOR
        assign X[i] = A[i] ^ B[i];
    end
endgenerate

endmodule