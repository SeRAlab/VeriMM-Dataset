module ripple_carry_adder(  
    input [3:0] A,  
    input [3:0] B,  
    output [4:0] SUM  
);  
    wire [3:0] carry;  
    assign SUM[0] = A[0] ^ B[0];  
    assign carry[0] = A[0] & B[0];  
    assign SUM[1] = A[1] ^ B[1] ^ carry[0];  
    assign carry[1] = (A[1] & B[1]) | (carry[0] & (A[1] ^ B[1]));  
    assign SUM[2] = A[2] ^ B[2] ^ carry[1];  
    assign carry[2] = (A[2] & B[2]) | (carry[1] & (A[2] ^ B[2]));  
    assign SUM[3] = A[3] ^ B[3] ^ carry[2];  
    assign SUM[4] = (A[3] & B[3]) | (carry[2] & (A[3] ^ B[3]));  
endmodule