module kogge_stone_adder(input [3:0] A,  
                         input [3:0] B,  
                         output [4:0] Sum);  
    wire [4:0] P; // Propagate  
    wire [4:0] G; // Generate  
    wire [4:0] C; // Carry  
   
    assign P = A ^ B;  
    assign G = A & B;  
   
    assign C[0] = 0;  
    assign C[1] = G[0];  
    assign C[2] = G[1] | (P[1] & C[1]);  
    assign C[3] = G[2] | (P[2] & C[2]);  
    assign C[4] = G[3] | (P[3] & C[3]);  
   
    assign Sum = P ^ C;  
endmodule