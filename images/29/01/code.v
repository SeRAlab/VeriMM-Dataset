module carry_skip_adder (  
    input [3:0] A,  
    input [3:0] B,  
    input Cin,  
    output [3:0] S,  
    output Cout  
);  
    wire [3:0] P; // Generate  
    wire [3:0] G; // Propagate  
    wire [3:0] C; // Carry  
    wire skip;  
   
    assign P = A ^ B;  // Propagate: A XOR B  
    assign G = A & B;  // Generate: A AND B  
   
    // Carry generation  
    assign C[0] = Cin;  
    assign C[1] = G[0] | (P[0] & C[0]);  
    assign C[2] = G[1] | (P[1] & C[1]);  
    assign C[3] = G[2] | (P[2] & C[2]);  
   
    // Sum calculation  
    assign S = P ^ C[3:0];  
    assign Cout = G[3] | (P[3] & C[3]);  
   
endmodule