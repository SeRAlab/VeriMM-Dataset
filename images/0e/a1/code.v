module brent_kung_adder (  
    input [3:0] A,  
    input [3:0] B,  
    output [3:0] S,  
    output Cout  
);  

    wire [3:0] P; // Propagate  
    wire [3:0] G; // Generate  
    wire [3:0] C; // Carry  

    assign P = A ^ B;  // Propagate signals  
    assign G = A & B;  // Generate signals  

    assign C[0] = G[0];  
    assign C[1] = G[1] | (P[1] & G[0]);  
    assign C[2] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]);  
    assign C[3] = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]);  

    assign S = P ^ C;  
    assign Cout = C[3];  

endmodule