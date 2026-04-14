module CLA_4bit(  
    input [3:0] A,  
    input [3:0] B,  
    input Cin,  
    output [3:0] S,  
    output Cout  
);  
    wire [3:0] G; // Generate  
    wire [3:0] P; // Propagate  
    wire [3:1] C; // Carry bits  

    assign G = A & B;  
    assign P = A ^ B;  
    assign C[1] = G[0] | (P[0] & Cin);  
    assign C[2] = G[1] | (P[1] & G[0]) | (P[1] & P[0] & Cin);  
    assign C[3] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]) | (P[2] & P[1] & P[0] & Cin);  
    assign Cout = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & Cin);  
    assign S = P ^ {C[2:1], Cin};  
endmodule