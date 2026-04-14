module carry_save_adder (  
    input [3:0] A,  
    input [3:0] B,  
    input [3:0] C,  
    output [3:0] S,  
    output [3:0] C_out  
);  
  
    wire [4:0] sum_ab;  
    wire [4:0] sum_abc;  
  
    assign sum_ab = {1'b0, A} + {1'b0, B};  
    assign S = sum_ab[3:0] + C;  
    assign C_out = sum_ab[4] + S[4];  
  
endmodule