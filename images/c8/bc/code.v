module binary_to_gray (
    input [7:0] binary,
    output [7:0] gray
);

assign gray = binary ^ {1'b0, binary[7:1]};

endmodule