module kogge_stone_adder #(parameter N = 4) (  
    input [N-1:0] A,  
    input [N-1:0] B,  
    output [N-1:0] Sum,  
    output Cout  
);  
    wire [N:0] G, P, C;  
    genvar i;  

    // Generate and Propagate signals  
    generate  
        for (i = 0; i < N; i = i + 1) begin: gp  
            assign G[i] = A[i] & B[i];  
            assign P[i] = A[i] ^ B[i];  
        end  
    endgenerate  

    // Carry generation  
    assign C[0] = 0;  
    generate  
        for (i = 0; i < N; i = i + 1) begin: carry  
            if (i == 0)  
                assign C[i+1] = G[i] | (P[i] & C[i]);  
            else  
                assign C[i+1] = G[i] | (P[i] & C[i]);  
        end  
    endgenerate  

    // Sum calculation  
    generate  
        for (i = 0; i < N; i = i + 1) begin: sum  
            assign Sum[i] = P[i] ^ C[i];  
        end  
    endgenerate  

    assign Cout = C[N];  

endmodule