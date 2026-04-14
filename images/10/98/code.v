module ip_checksum (
    input [15:0] data_in,
    input [15:0] data_in2,
    output [15:0] checksum
);
    wire [16:0] sum;
    assign sum = data_in + data_in2;
    assign checksum = ~sum[15:0] + sum[16]; // One's complement with carry
endmodule