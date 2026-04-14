module checksum_calculator(
    input [7:0] data_in,
    output reg [7:0] checksum_out
);
    always @(*) begin
        checksum_out = data_in[0] + data_in[1] + data_in[2] + data_in[3] +
                       data_in[4] + data_in[5] + data_in[6] + data_in[7];
        checksum_out = checksum_out % 256; // Ensure it stays within 8 bits
    end
endmodule