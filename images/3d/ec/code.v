module ip_checksum (
    input [15:0] data_in,
    output [15:0] checksum_out
);
    wire [16:0] sum;
    assign sum = data_in + 16'h0000; // Initial sum with zero

    // One's complement calculation
    assign checksum_out = ~sum[15:0]; // Negate the sum to get the checksum
endmodule