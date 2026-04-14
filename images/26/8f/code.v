module cla_4bit (  
    input [3:0] A,  
    input [3:0] B,  
    input Cin,  
    output [3:0] Sum,  
    output Cout  
);  
    wire [3:0] P;  // Propagate  
    wire [3:0] G;  // Generate  
    wire [3:0] C;  // Carry  

    // Generate and Propagate equations  
    assign P = A ^ B;  
    assign G = A & B;  
  
    // Carry equations  
    assign C[0] = G[0] | (P[0] & Cin);  
    assign C[1] = G[1] | (P[1] & G[0]) | (P[1] & P[0] & Cin);  
    assign C[2] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]) | (P[2] & P[1] & P[0] & Cin);  
    assign C[3] = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]) | (P[3] & P[2] & P[1] & P[0] & Cin);  
  
    // Sum equations  
    assign Sum = P ^ {C[2:0], Cin};  
    assign Cout = C[3];  
endmodule