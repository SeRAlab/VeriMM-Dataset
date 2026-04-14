module ip_checksum (
    input [15:0] data_in,
    output [15:0] checksum_out
);
    wire [16:0] sum; // 17 bits to accommodate potential overflow
    assign sum = data_in + 16'h0000; // sum the 16-bit input
    
    // Calculate the one's complement
    assign checksum_out = ~sum[15:0]; // take one's complement of lower 16 bits
endmodule