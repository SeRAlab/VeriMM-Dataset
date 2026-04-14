module checksum_checker (
    input [7:0] data_in,
    input [3:0] expected_checksum,
    output reg valid
);
    integer i;
    reg [3:0] computed_checksum;

    always @(*) begin
        computed_checksum = 4'b0000;
        for (i = 0; i < 8; i = i + 1) begin
            computed_checksum = computed_checksum + data_in[i];
        end
        valid = (computed_checksum == expected_checksum);
    end
endmodule