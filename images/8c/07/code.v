module bin_to_gray (
    input wire [3:0] binary,
    output wire [3:0] gray
);

    assign gray = {binary[3], binary[3] ^ binary[2], binary[2] ^ binary[1], binary[1] ^ binary[0]};

endmodule