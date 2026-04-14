module top_module(
    input A,
    input SLEEP,
    output X
);wire B;
    assign B = 1'b0;

    assign X = (SLEEP == 1'b1) ? 1'b0 : (A | B);

endmodule