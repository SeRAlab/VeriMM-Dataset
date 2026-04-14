module ip_checksum (
    input [63:0] data,
    output reg [15:0] checksum
);
    reg [31:0] sum;

    always @(*) begin
        sum = data[15:0] + data[31:16] + data[47:32] + data[63:48];
        checksum = ~sum[15:0] + sum[31:16]; // One's complement
    end
endmodule