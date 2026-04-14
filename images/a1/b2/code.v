module top_module(
    input [3:0] A,
    input [3:0] B,
    input carry_in,
    output [3:0] sum,
    output carry_out
);wire [3:0] carry;
    
    assign sum = A + B + carry_in;
    
    assign carry[0] = (A[0] & B[0]) | (carry_in & A[0]) | (carry_in & B[0]);
    assign carry[1] = (A[1] & B[1]) | (carry[0] & A[1]) | (carry[0] & B[1]);
    assign carry[2] = (A[2] & B[2]) | (carry[1] & A[2]) | (carry[1] & B[2]);
    assign carry[3] = (A[3] & B[3]) | (carry[2] & A[3]) | (carry[2] & B[3]);
    
    assign carry_out = carry[3];
    
endmodule