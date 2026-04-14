module checksum (
    input [4:0] data,
    output [1:0] checksum,
    output parity
);
    wire [2:0] sum;

    assign sum = data[0] + data[1] + data[2] + data[3] + data[4];
    assign checksum = sum[1:0]; // Taking modulo 4 (last 2 bits)
    assign parity = sum[0]; // Even (0) or odd (1)

endmodule