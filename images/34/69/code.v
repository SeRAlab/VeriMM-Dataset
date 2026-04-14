module BrentKungAdder (  
    input [4:0] A,  
    input [4:0] B,  
    output [4:0] Sum,  
    output CarryOut  
);  
    wire [4:0] G; // Generate  
    wire [4:0] P; // Propagate  
    wire [4:0] C; // Carry  

    // Generate and Propagate  
    assign G = A & B;  
    assign P = A ^ B;  

    // Carry generation  
    assign C[0] = 1'b0;  
    assign C[1] = G[0] | (P[0] & C[0]);  
    assign C[2] = G[1] | (P[1] & C[1]);  
    assign C[3] = G[2] | (P[2] & C[2]);  
    assign C[4] = G[3] | (P[3] & C[3]);  

    // Sum calculation  
    assign Sum = P ^ C[4:0];  
    assign CarryOut = C[4];  
endmodule