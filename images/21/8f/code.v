module checksum_calculator (
    input [7:0] data_in,
    output reg [7:0] checksum_out
);
    integer i;
    reg [7:0] sum;

    always @(*) begin
        sum = 8'b0;
        for (i = 0; i < 8; i = i + 1) begin
            sum = sum + data_in[i];
        end
        checksum_out = sum % 256;
    end
endmodule