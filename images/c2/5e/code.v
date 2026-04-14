module mux4to1(
    input [3:0] I,
    input [1:0] S,
    output O
);

    wire [1:0] notS;
    wire [3:0] and0, and1, and2, and3;
    
    assign notS = ~S;
    
    assign and0 = I[0] & ~S[1] & ~S[0];
    assign and1 = I[1] & ~S[1] & S[0];
    assign and2 = I[2] & S[1] & ~S[0];
    assign and3 = I[3] & S[1] & S[0];
    
    assign O = and0 | and1 | and2 | and3;
    
endmodule