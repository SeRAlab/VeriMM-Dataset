module DAC_24bit (
    input [23:0] data_in,
    output [23:0] data_out
);
    assign data_out = (data_in << 1) & 24'hFFFFFF; // Shift left and mask to 24 bits
endmodule