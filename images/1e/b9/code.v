module checksum_verifier (
    input [7:0] data,
    input [7:0] checksum,
    output reg valid
);
    integer i;
    reg [7:0] computed_checksum;

    always @* begin
        computed_checksum = 8'b0;
        for (i = 0; i < 8; i = i + 1) begin
            computed_checksum = computed_checksum + data[i];
        end
        valid = (computed_checksum == checksum);
    end
endmodule