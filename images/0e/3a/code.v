module ripple_carry_adder (  
    input [3:0] A,  
    input [3:0] B,  
    input Cin,  
    output [4:0] Sum  
);  
    wire [3:0] C;  
    assign Sum[0] = A[0] ^ B[0] ^ Cin;  
    assign C[0] = (A[0] & B[0]) | (Cin & (A[0] ^ B[0]));  
    assign Sum[1] = A[1] ^ B[1] ^ C[0];  
    assign C[1] = (A[1] & B[1]) | (C[0] & (A[1] ^ B[1]));  
    assign Sum[2] = A[2] ^ B[2] ^ C[1];  
    assign C[2] = (A[2] & B[2]) | (C[1] & (A[2] ^ B[2]));  
    assign Sum[3] = A[3] ^ B[3] ^ C[2];  
    assign Sum[4] = (A[3] & B[3]) | (C[2] & (A[3] ^ B[3]));  
endmodule