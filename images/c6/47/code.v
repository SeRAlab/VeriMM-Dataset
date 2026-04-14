module XOR_GATE (
    input A,
    input B,
    output C
);
    wire w1, w2, w3;
    
    assign w1 = A & ~B;
    assign w2 = ~A & B;
    assign w3 = w1 | w2;
    
    assign C = w3;
endmodule