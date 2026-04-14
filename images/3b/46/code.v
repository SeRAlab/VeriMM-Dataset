module ip_checksum (
    input [15:0] data_in,
    output reg [15:0] checksum_out
);

reg [31:0] sum; // 32-bit sum to accommodate overflow

always @(*) begin
    sum = 0; // Initialize sum
    sum = sum + data_in; // Add the data word
    checksum_out = ~sum[15:0]; // One's complement of the sum
end

endmodule