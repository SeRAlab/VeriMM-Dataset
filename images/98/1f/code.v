module top_module(
    X,
    A,
    B,
    C,
    D
);output X;
    input  A;
    input  B;
    input  C;
    input  D;

    // Replace with the correct AND gate module
    wire and_output;

    // Assuming there's a more generic 4-input AND gate available
    assign and_output = A & B & C & D; 
    assign X = and_output;

endmodule