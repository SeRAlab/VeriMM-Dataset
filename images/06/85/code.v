module checksum_calculator (
    input [7:0] data_in,
    output [7:0] checksum_out
);
    wire [8:0] sum; // 9 bits to handle overflow
    assign sum = data_in + 8'b00000001; // Add 1 for 2's complement
    assign checksum_out = ~sum[7:0]; // Invert the sum to get the 2's complement
endmodule