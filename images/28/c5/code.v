module checksum_calculator(
    input [7:0] data,
    output [3:0] checksum
);
    assign checksum = data[3:0] + data[7:4];
endmodule