module ripple_carry_adder(  
    input [3:0] A,  
    input [3:0] B,  
    input Cin,  
    output [4:0] Sum,  
    output Cout  
);  
    wire c1, c2, c3;  

    // Full adder for the least significant bit  
    assign Sum[0] = A[0] ^ B[0] ^ Cin;  
    assign c1 = (A[0] & B[0]) | (Cin & (A[0] ^ B[0]));  

    // Full adder for the second bit  
    assign Sum[1] = A[1] ^ B[1] ^ c1;  
    assign c2 = (A[1] & B[1]) | (c1 & (A[1] ^ B[1]));  

    // Full adder for the third bit  
    assign Sum[2] = A[2] ^ B[2] ^ c2;  
    assign c3 = (A[2] & B[2]) | (c2 & (A[2] ^ B[2]));  

    // Full adder for the most significant bit  
    assign Sum[3] = A[3] ^ B[3] ^ c3;  
    assign Cout = (A[3] & B[3]) | (c3 & (A[3] ^ B[3]));  

    assign Sum[4] = Cout;  
endmodule