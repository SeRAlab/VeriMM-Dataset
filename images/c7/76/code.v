module four_to_one (
    input [3:0] in,
    output out
);

    assign out = |in;

endmodule