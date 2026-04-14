module ip_checksum (
    input [15:0] data_in,
    output [15:0] checksum
);
    reg [31:0] sum;
    wire [15:0] word;

    assign word = data_in;
    always @(*) begin
        sum = sum + word;
    end

    assign checksum = ~sum[15:0]; // One's complement of the lower 16 bits
endmodule