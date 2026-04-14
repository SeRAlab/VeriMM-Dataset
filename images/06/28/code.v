module checksum_calculator (
    input [7:0] data_in,
    input [7:0] checksum_in,
    output reg valid_checksum
);

    reg [8:0] sum; // 9-bit to accommodate carry

    always @(*) begin
        sum = 0;
        sum = sum + data_in; // add the input data
        valid_checksum = (sum[7:0] ^ 8'hFF) == checksum_in; // compare 1's complement of sum with checksum
    end

endmodule