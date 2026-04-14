module binary_to_gray
(
    input [2:0] binary,
    output [2:0] gray
);

    assign gray = binary ^ (binary >> 1);

endmodule