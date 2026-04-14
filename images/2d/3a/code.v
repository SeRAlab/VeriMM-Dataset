module carry_save_adder (  
    input [3:0] A,  
    input [3:0] B,  
    input [3:0] Cin,  
    output [3:0] Sum,  
    output Cout  
);  
    wire [3:0] S1, S2, C1, C2;  
    wire [3:0] temp_sum;  
    wire [3:0] temp_carry;  

    // First level of addition  
    assign S1 = A ^ B;  
    assign C1 = A & B;  

    // Second level of addition  
    assign S2 = S1 ^ Cin;  
    assign C2 = S1 & Cin;  

    // Final sum and carry-out  
    assign Sum = S2 ^ (C1 << 1) ^ C2;  
    assign Cout = (C1[3] | C2[3]) | (C1[2] & C2[2]) | (C1[1] & C2[1]) | (C1[0] & C2[0]);  

endmodule