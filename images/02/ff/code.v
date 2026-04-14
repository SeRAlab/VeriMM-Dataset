module wallace_tree_adder (  
    input [3:0] A,  
    input [3:0] B,  
    input [3:0] C,  
    output [4:0] SUM  
);  
    wire [3:0] S1, C1, S2, C2;  
    wire [3:0] P1, P2, P3;  
  
    // First level of addition (A + B)  
    assign P1 = A & B;  
    assign S1 = A ^ B;  
  
    // Second level of addition (S1 + C)  
    assign P2 = S1 & C;  
    assign S2 = S1 ^ C;  
  
    // Final level of carry-save addition  
    assign P3 = P1 | P2;  
    assign C1 = P1;  
    assign C2 = P2;  
    assign SUM = {1'b0, S2} + P3;  
  
endmodule