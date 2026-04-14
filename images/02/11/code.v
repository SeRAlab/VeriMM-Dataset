module two_bit_adder (  
    input [1:0] A,  
    input [1:0] B,  
    output [1:0] S,  
    output C_out  
);  
    wire c1;  
    assign S = A ^ B;  
    assign c1 = (A[0] & B[0]);  
    assign S[1] = A[1] ^ B[1] ^ c1;  
    assign C_out = (A[1] & B[1]) | (c1);  
endmodule