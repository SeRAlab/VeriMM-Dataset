module ip_checksum (
    input [127:0] data,      // 8 pairs of 16-bit words
    output reg [15:0] checksum // 16-bit checksum output
);
    integer i;
    reg [31:0] sum;          // Temporary sum storage

    always @(*) begin
        sum = 0;
        for (i = 0; i < 8; i = i + 1) begin
            sum = sum + data[16*i +: 16]; // Sum each 16-bit word
        end
        checksum = ~sum[15:0] + sum[31:16]; // One's complement
    end
endmodule