module ip_checksum (
    input [31:0] data,
    input start,
    output reg [15:0] checksum,
    output reg valid
);
    reg [15:0] sum1, sum2;

    always @(*) begin
        if (start) begin
            sum1 = data[15:0] + data[31:16];
            checksum = ~sum1; // One's complement
            valid = 1;
        end else begin
            checksum = 16'b0;
            valid = 0;
        end
    end
endmodule