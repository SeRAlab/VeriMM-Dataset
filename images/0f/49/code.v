module checksum_calculator (
    input [15:0] data_in,
    output [7:0] checksum_out
);
    wire [7:0] byte1;
    wire [7:0] byte2;
    wire [8:0] sum;

    assign byte1 = data_in[7:0];          // Low byte
    assign byte2 = data_in[15:8];         // High byte
    assign sum = byte1 + byte2;           // Sum of the bytes
    assign checksum_out = sum[7:0];       // Least significant byte of the sum
endmodule