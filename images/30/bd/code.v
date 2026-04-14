module DAC_24bit (
    input [23:0] data_in,
    output [7:0] data_out
);
    assign data_out = data_in[23:16]; // Upper 8 bits of the 24-bit input
endmodule