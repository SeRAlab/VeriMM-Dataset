module checksum(
    input [7:0] data_in,
    output [3:0] checksum_out
);
    wire [3:0] sum;
    assign sum = data_in[0] + data_in[1] + data_in[2] + data_in[3] + 
                 data_in[4] + data_in[5] + data_in[6] + data_in[7];
    
    assign checksum_out = sum[3:0]; // Wrap around using lower 4 bits
endmodule