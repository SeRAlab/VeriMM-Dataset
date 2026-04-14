module DAC_8_to_10 (
    input [7:0] data_in,
    output [9:0] data_out
);
    assign data_out = data_in * 4; // Multiply input by 4 to scale from 8-bit to 10-bit
endmodule