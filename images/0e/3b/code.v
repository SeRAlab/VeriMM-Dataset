module checksum_calculator (
    input [3:0] data,
    output [3:0] checksum
);
    wire [4:0] sum; // 5 bits to accommodate overflow
    assign sum = data + 4'b0001; // Adding 1 to data for 1's complement
    assign checksum = ~sum[3:0]; // 1's complement of the lower 4 bits
endmodule