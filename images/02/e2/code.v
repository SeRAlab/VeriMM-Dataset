module KoggeStoneAdder #(parameter N = 8) (  
    input [N-1:0] A,  
    input [N-1:0] B,  
    output [N-1:0] S,  
    output C_out  
);  
    wire [N:0] P, G, C;  
    assign P = A ^ B;  
    assign G = A & B;  

    // Carry generation  
    assign C[0] = 0;  
    genvar i;  
    generate  
        for (i = 0; i < N; i = i + 1) begin: carry_gen  
            assign C[i+1] = G[i] | (P[i] & C[i]);  
        end  
    endgenerate  

    // Sum calculation  
    assign S = P ^ C[N-1:0];  
    assign C_out = C[N];  
endmodule