module magnitude_comparator (
    input [3:0] A,
    input [3:0] B,
    input mode,
    output result
);

    assign result = (mode == 0) ? (A > B) : (A < B);

endmodule