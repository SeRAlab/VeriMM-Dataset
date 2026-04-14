module mux_4to1(A, B, C, D, S, Y);
    input A, B, C, D;
    input [1:0] S;
    output Y;
    
    wire S0, S1;
    wire nS0, nS1;
    wire wA, wB, wC, wD;
    
    assign S0 = S[0];
    assign S1 = S[1];
    assign nS0 = ~S0;
    assign nS1 = ~S1;
    
    assign wA = A & nS1 & nS0;
    assign wB = B & nS1 & S0;
    assign wC = C & S1 & nS0;
    assign wD = D & S1 & S0;
    
    assign Y = wA | wB | wC | wD;
endmodule