module KoggeStoneAdder(input [4:0] A, input [4:0] B, output [5:0] S);  
    wire [4:0] G; // Generate  
    wire [4:0] P; // Propagate  
    wire [5:0] C; // Carry  
  
    assign G = A & B;  
    assign P = A ^ B;  
    assign C[0] = 1'b0; // No carry in for the first bit  
  
    // Carry generation  
    assign C[1] = G[0] | (P[0] & C[0]);  
    assign C[2] = G[1] | (P[1] & C[1]);  
    assign C[3] = G[2] | (P[2] & C[2]);  
    assign C[4] = G[3] | (P[3] & C[3]);  
    assign C[5] = G[4] | (P[4] & C[4]);  
  
    // Sum generation  
    assign S = P ^ C[4:0];  
endmodule