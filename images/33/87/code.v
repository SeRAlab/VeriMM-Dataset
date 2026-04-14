module ip_checksum (
    input [15:0] data_in,
    output [15:0] checksum_out
);

wire [16:0] sum;

assign sum = data_in + 16'hFFFF; // Adding one's complement of data
assign checksum_out = ~sum[15:0];  // One's complement of the sum

endmodule