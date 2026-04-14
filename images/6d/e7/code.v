module zero_detector(
    input [7:0] data,
    output zero
);

    assign zero = (data == 8'b00000000) ? 1'b1 : 1'b0; // Check if all bits are zero

endmodule