module top_module(
    input A,
    input B,
    input S,
    output Y
);wire X;
    wire A1;
    wire A2;
    wire B1_N;
    
    assign A1 = A;
    assign A2 = B;
    assign B1_N = S;

    // Implementing the 2-to-1 MUX logic directly instead of using the unknown module
    assign X = (B1_N) ? A2 : A1; // Multiplexer logic

    assign Y = X;

endmodule