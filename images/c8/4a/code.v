module boolean_function (
    input A,
    input B,
    input C,
    output X
);

    assign X = (A & B) | (~A & C);

endmodule