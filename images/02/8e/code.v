module eight_bit_adder (
    input [7:0] A,
    input [7:0] B,
    output [7:0] S,
    output C_out,
    output V
);
    wire [8:0] temp_sum;

    assign temp_sum = {1'b0, A} + {1'b0, B}; // 9-bit to accommodate carry
    assign S = temp_sum[7:0];
    assign C_out = temp_sum[8];
    assign V = (A[7] == B[7]) && (A[7] != S[7]); // Overflow detection
endmodule