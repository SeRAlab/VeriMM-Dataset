module DAC_24bit (
    input wire [23:0] data_in,
    input wire enable,
    output wire [23:0] data_out
);
    assign data_out = enable ? data_in : 24'b0;
endmodule