module ip_checksum (
    input [15:0] data_in,
    output reg [15:0] checksum_out
);
    reg [31:0] sum;

    always @(*) begin
        sum = data_in; // Initialize sum with the input data
        // The checksum calculation (for simplicity, consider a single word input)
        checksum_out = ~sum[15:0]; // One's complement of the input
    end
endmodule