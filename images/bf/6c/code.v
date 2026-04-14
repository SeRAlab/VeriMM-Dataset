module top_module(
    input A,
    input B,
    input S,
    output Y
);wire A1;
    wire A2;
    wire B1_N;

    assign A1 = A;
    assign A2 = B;
    assign B1_N = S;

    assign Y = (B1_N) ? A2 : A1; // Changed the implementation to a simple conditional assignment

endmodule