module top_module(
    input signed [3:0] A,
    input signed [3:0] B,
    output signed [3:0] sum,
    output carry_out
);wire [3:0] carry;
    
    assign sum = A + B;
    
    assign carry[0] = A[0] & B[0];
    assign carry[1] = (A[1] & B[1]) | (A[1] & carry[0]) | (B[1] & carry[0]);
    assign carry[2] = (A[2] & B[2]) | (A[2] & carry[1]) | (B[2] & carry[1]);
    assign carry[3] = (A[3] & B[3]) | (A[3] & carry[2]) | (B[3] & carry[2]);
    
    assign carry_out = carry[3];
    
endmodule