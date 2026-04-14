module checksum_calculator (
    input wire [7:0] data_in,
    input wire [7:0] expected_checksum,
    output reg [7:0] calculated_checksum,
    output reg is_valid
);
    integer i;
    always @(*) begin
        calculated_checksum = 0;
        for (i = 0; i < 8; i = i + 1) begin
            calculated_checksum = calculated_checksum + data_in[i];
        end
        calculated_checksum = calculated_checksum % 256;
        is_valid = (calculated_checksum == expected_checksum);
    end
endmodule