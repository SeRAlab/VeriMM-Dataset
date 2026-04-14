module checksum_calculator (
    input [3:0] data,
    output [3:0] checksum
);
    assign checksum = data[0] + data[1] + data[2] + data[3]; // sum of bits, modulo 16
endmodule