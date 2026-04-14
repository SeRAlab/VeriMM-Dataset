module binary_to_gray (
    input [7:0] binary,
    output [7:0] gray
);
    assign gray = binary ^ (binary >> 1);
endmodule