module carry_skip_adder #(parameter N = 4) (  
    input [N-1:0] A,  
    input [N-1:0] B,  
    input Cin,  
    output [N-1:0] S,  
    output Cout  
);  
    wire [N:0] C;  
    wire [N-1:0] P, G;  
    genvar i;  

    // Propagate and Generate signals  
    assign P = A ^ B;  
    assign G = A & B;  

    // Generate carries  
    assign C[0] = Cin;  
    generate  
        for (i = 0; i < N; i = i + 1) begin: carry_gen  
            assign C[i + 1] = G[i] | (P[i] & C[i]);  
        end  
    endgenerate  

    // Sum output  
    assign S = P ^ C[N-1:0];  
    assign Cout = C[N];  
endmodule