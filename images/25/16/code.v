module carry_save_adder (  
    input [3:0] A,  
    input [3:0] B,  
    input [3:0] C,  
    output [4:0] S,  
    output [4:0] C_out  
);  
    wire [4:0] sum1, sum2;  
    wire [4:0] carry1, carry2;  

    // First stage of CSA
    assign sum1 = A + B;  
    assign carry1 = {1'b0, sum1[3:1]};  

    // Second stage of CSA
    assign sum2 = sum1 + C;  
    assign carry2 = {1'b0, sum2[3:1]};  

    // Final outputs
    assign S = sum2;  
    assign C_out = carry1 + carry2;  
endmodule