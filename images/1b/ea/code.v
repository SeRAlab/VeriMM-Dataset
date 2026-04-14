module xnor_5input (
    input [4:0] A, // 5-bit input
    output Y       // Output of XNOR
);
    assign Y = ~(A[0] ^ A[1] ^ A[2] ^ A[3] ^ A[4]);
endmodule