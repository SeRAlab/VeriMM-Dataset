module binary_to_gray (
    input [2:0] binary,
    output [2:0] gray);
assign gray[2] = binary[2];
assign gray[1] = binary[2] ^ binary[1];
assign gray[0] = binary[1] ^ binary[0];
endmodule