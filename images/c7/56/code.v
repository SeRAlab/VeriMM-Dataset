module three_to_one (
    input a,
    input b,
    input c,
    output out
);

    assign out = (a & b & c) | ((a & b) | (a & c) | (b & c));

endmodule