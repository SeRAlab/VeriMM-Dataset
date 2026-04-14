module ip_checksum (
    input [15:0] data0,
    input [15:0] data1,
    input [15:0] data2,
    input [15:0] data3,
    input [15:0] data4,
    output reg [15:0] checksum
);

reg [31:0] sum;

always @(*) begin
    sum = data0 + data1 + data2 + data3 + data4; // Sum all 16-bit words
    checksum = ~sum[15:0] + sum[31:16]; // One's complement and handle overflow
    if (sum[31:16] != 0) begin
        checksum = checksum + 1; // Handle carry out if overflow occurs
    end
end

endmodule