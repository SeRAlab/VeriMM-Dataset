module checksum_calculator (
    input [7:0] data_in,
    output [7:0] checksum_out
);
    assign checksum_out = data_in ^ 8'b11111111; // Simple checksum using XOR with all 1's
endmodule