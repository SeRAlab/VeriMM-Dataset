module carry_save_adder (  
    input [3:0] A,  
    input [3:0] B,  
    input [3:0] C,  
    output [4:0] S,  
    output [3:0] Cout  
);  
    wire [4:0] sum_ab;  
    wire [4:0] sum_abc;  
    wire [3:0] carry_ab;  
    wire [3:0] carry_abc;  

    // Intermediate sums and carries  
    assign sum_ab = A ^ B;  
    assign carry_ab = (A & B) << 1;  

    assign sum_abc = sum_ab ^ C;  
    assign carry_abc = (sum_ab & C) << 1;  

    assign S = sum_abc ^ carry_ab ^ carry_abc;  
    assign Cout = (carry_ab[3:0] + carry_abc[3:0]) >> 1;  
endmodule