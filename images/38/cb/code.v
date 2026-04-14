module carry_save_adder (  
    input [3:0] A,  
    input [3:0] B,  
    input [3:0] C,  
    output [3:0] sum,  
    output [3:0] carry  
);  
    wire [3:0] c1, c2;  
    wire [3:0] s1, s2;  
   
    assign s1 = A ^ B;  
    assign c1 = A & B;  
   
    assign s2 = s1 ^ C;  
    assign c2 = c1 | (s1 & C);  
   
    assign sum = s2;  
    assign carry = c2;  
endmodule