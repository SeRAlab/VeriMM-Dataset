module nand_gate (
    input wire [4:0] A, // 5 inputs
    output wire Y       // NAND output
);
    assign Y = ~(A[0] & A[1] & A[2] & A[3] & A[4]); // NAND logic
endmodule