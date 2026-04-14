module CLA_4bit (  
    input [3:0] A,  
    input [3:0] B,  
    input Cin,  
    output [4:0] Sum,  
    output Cout  
);  
    wire [3:0] P; // Generate propagate signals  
    wire [3:0] G; // Generate signals  
    wire [3:0] C; // Carry signals  

    // Propagate and Generate  
    assign P = A ^ B;  
    assign G = A & B;  

    // Carry signals  
    assign C[0] = G[0] | (P[0] & Cin);  
    assign C[1] = G[1] | (P[1] & C[0]);  
    assign C[2] = G[2] | (P[2] & C[1]);  
    assign C[3] = G[3] | (P[3] & C[2]);  

    // Sum and Carry Out  
    assign Sum = P ^ {C[3:1], Cin};  
    assign Cout = C[3];  

endmodule