module checksum_calculator (
    input [7:0] data_in,
    output [7:0] checksum_out
);
    assign checksum_out = data_in[7:0] + 8'b00000000; // Initialize with 0 for checksum
endmodule