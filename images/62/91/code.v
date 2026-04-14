module top_module(
    input A1,
    input A2,
    input B1,
    input B2,
    input C1,
    output X
);// assign the output signal X to the sum of all the input signals
    assign X = A1 + A2 + B1 + B2 + C1;

endmodule