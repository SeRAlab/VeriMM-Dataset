module brent_kung_adder (  
    input [4:0] A,  
    input [4:0] B,  
    output [4:0] SUM,  
    output C_OUT  
);  

wire [4:0] P; // Propagate  
wire [4:0] G; // Generate  
wire [4:0] C; // Carry  

assign P = A ^ B; // Propagate  
assign G = A & B; // Generate  

// Carry logic using Brent-Kung method  
assign C[0] = 0; // No carry in for the first stage  
assign C[1] = G[0] | (P[0] & C[0]);  
assign C[2] = G[1] | (P[1] & G[0]) | (P[1] & P[0] & C[0]);  
assign C[3] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]) | (P[2] & P[1] & P[0] & C[0]);  
assign C[4] = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]) | (P[3] & P[2] & P[1] & P[0] & C[0]);  

assign C_OUT = C[4];  
assign SUM = P ^ C[4:0];  

endmodule