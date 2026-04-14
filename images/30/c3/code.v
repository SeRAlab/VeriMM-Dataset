module checksum_calculator (
    input [31:0] data_in,
    output [7:0] checksum_out
);
    assign checksum_out = (data_in[7:0] + data_in[15:8] + data_in[23:16] + data_in[31:24]) & 8'hFF;
endmodule