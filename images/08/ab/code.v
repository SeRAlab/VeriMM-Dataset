module checksum_calculator (
    input [15:0] data_in,
    input [7:0] external_checksum,
    output reg [7:0] checksum_out,
    output reg valid
);

always @(*) begin
    // Calculate checksum as the sum of bits and take modulo 256
    checksum_out = (data_in[15:0] % 256);
    // Check if the calculated checksum matches the external checksum
    valid = (checksum_out == external_checksum);
end

endmodule