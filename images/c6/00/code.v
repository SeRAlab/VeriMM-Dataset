module mux_2to1 (
    input A,
    input B,
    input S,
    output Y
);
    wire notS;
    assign notS = ~S;
    
    wire and1, and2;
    assign and1 = A & notS;
    assign and2 = B & S;
    
    assign Y = and1 | and2;
endmodule