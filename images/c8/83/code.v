module four_to_one(
    input in1,
    input in2,
    input in3,
    input in4,
    output out
);

    assign out = (in1 || in2 || in3) ? 1'b1 : 1'b0;

endmodule