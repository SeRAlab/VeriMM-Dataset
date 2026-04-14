module carry_save_adder(  
    input [4:0] A,  
    input [4:0] B,  
    input [4:0] C,  
    output [5:0] S,  
    output [1:0] Cout  
);  
    wire [5:0] sum_ab, sum_abc;  
    wire [4:0] carry_ab, carry_abc;  

    // Adding A and B  
    assign {carry_ab, sum_ab} = A + B;  

    // Adding sum_ab and C  
    assign {carry_abc, sum_abc} = sum_ab + C;  

    assign S = sum_abc;  
    assign Cout = carry_ab + carry_abc;  
endmodule