module checksum_calculator (
    input [3:0] data_in,
    output checksum
);
    assign checksum = data_in[0] ^ data_in[1] ^ data_in[2] ^ data_in[3]; // XOR for checksum
endmodule