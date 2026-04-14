module ip_checksum (
    input [15:0] data_in,
    output [15:0] checksum
);
    wire [16:0] sum;
    assign sum = data_in + 16'h0000; // Here, we are just adding the input as a 16-bit number.
    assign checksum = ~sum[15:0]; // Take one's complement
endmodule