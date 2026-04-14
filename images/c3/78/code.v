module ripple_carry_adder(
    input [3:0] A,
    input [3:0] B,
    input CIN,
    output [3:0] S,
    output COUT
);
    
    wire [3:0] C;
    
    assign S = A + B + CIN;
    
    assign C[0] = (A[0] & B[0]) | (A[0] & CIN) | (B[0] & CIN);
    assign C[1] = (A[1] & B[1]) | (A[1] & C[0]) | (B[1] & C[0]);
    assign C[2] = (A[2] & B[2]) | (A[2] & C[1]) | (B[2] & C[1]);
    assign C[3] = (A[3] & B[3]) | (A[3] & C[2]) | (B[3] & C[2]);
    
    assign COUT = C[3];
    
endmodule