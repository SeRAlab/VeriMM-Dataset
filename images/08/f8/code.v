module nor_gate (
    input wire [3:0] A,  // 4-bit input
    output wire Y        // Output
);
    assign Y = ~(A[0] | A[1] | A[2] | A[3]); // NOR operation
endmodule