module KoggeStoneAdder (input [4:0] A, input [4:0] B, output [4:0] S, output carry_out);  
    wire [4:0] P, G;  
    wire [4:0] C;  

    // Generate and propagate signals  
    assign P = A ^ B;  
    assign G = A & B;  

    // Carry computation  
    assign C[0] = G[0];  
    assign C[1] = G[1] | (P[1] & C[0]);  
    assign C[2] = G[2] | (P[2] & C[1]);  
    assign C[3] = G[3] | (P[3] & C[2]);  
    assign C[4] = G[4] | (P[4] & C[3]);  

    // Sum computation  
    assign S = P ^ C;  
    assign carry_out = C[4];  
endmodule