module checksum_generator_checker (
    input [7:0] data_in,
    input [3:0] expected_checksum,
    output reg [3:0] checksum_out,
    output reg valid
);
    always @(*) begin
        // Calculate checksum
        checksum_out = data_in[0] + data_in[1] + data_in[2] + data_in[3] +
                       data_in[4] + data_in[5] + data_in[6] + data_in[7];
        checksum_out = checksum_out % 16; // modulo 16

        // Check if the generated checksum matches the expected checksum
        valid = (checksum_out == expected_checksum);
    end
endmodule