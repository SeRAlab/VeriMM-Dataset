module top_module(
    output X,
    input  A,
    input  B,
    input  C,
    input  D
);wire w1, w2, w3;
    
    // Use a simple AND gate for the 4-input AND operation
    assign w1 = A & B;
    assign w2 = C & D;
    assign w3 = w1 & w2;
    assign X = w3;

endmodule