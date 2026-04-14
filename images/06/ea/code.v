module KoggeStoneAdder(  
    input [4:0] A,  
    input [4:0] B,  
    output [4:0] SUM,  
    output COUT  
);  
    wire [4:0] G, P, C;  
    assign G = A & B;  
    assign P = A ^ B;  
    assign C[0] = 0;  
    assign C[1] = G[0] | (P[0] & C[0]);  
    assign C[2] = G[1] | (P[1] & C[1]);  
    assign C[3] = G[2] | (P[2] & C[2]);  
    assign C[4] = G[3] | (P[3] & C[3]);  
    assign SUM = P ^ C[4:0];  
    assign COUT = G[4] | (P[4] & C[4]);  
endmodule