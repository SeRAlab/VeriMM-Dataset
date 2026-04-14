module bin2gray(
    input [3:0] binary,
    output [3:0] gray);

    assign gray = (binary >> 1) ^ binary;

endmodule