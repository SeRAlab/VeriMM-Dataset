module carry_skip_adder (  
    input [3:0] A,  
    input [3:0] B,  
    output [4:0] SUM  
);  
    wire [3:0] P; // propagate  
    wire [3:0] G; // generate  
    wire [4:0] C; // carries  
    wire C_skip; // carry skip logic  

    assign P = A ^ B;  
    assign G = A & B;  
    assign C[0] = 1'b0; // Initial carry is 0  

    // Generate carries  
    genvar i;  
    generate  
        for (i = 0; i < 4; i = i + 1) begin: carry_gen  
            assign C[i + 1] = G[i] | (P[i] & C[i]);  
        end  
    endgenerate  

    // Carry skip logic (using a simple 1-bit skip)  
    assign C_skip = G[0] | (P[0] & G[1]) | (P[0] & P[1] & G[2]) | (P[0] & P[1] & P[2] & G[3]);  

    assign SUM = {C_skip, A} + {C_skip, B};  

endmodule