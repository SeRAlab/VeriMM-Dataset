module top_module (
    input [3:0] binary,
    output [3:0] gray
);

    assign gray = binary ^ (binary >> 1); // Binary to Gray code conversion

endmodule