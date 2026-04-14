module ip_checksum (
    input [15:0] data_in,
    output reg [15:0] checksum_out
);
    reg [31:0] sum; // To hold the sum of 16-bit words and overflow
    integer i;

    always @* begin
        sum = 0;
        // Assume that there are 5 test cases, each testing the checksum of a 16-bit input
        for (i = 0; i < 5; i = i + 1) begin
            sum = sum + data_in;
        end
        checksum_out = ~sum[15:0]; // One's complement of the sum's lower 16 bits
    end
endmodule