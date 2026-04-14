module ip_checksum (
    input wire [15:0] data,
    input wire end_signal,
    output reg [15:0] checksum
);
    reg [15:0] sum;

    always @(*) begin
        if (end_signal) begin
            checksum = ~sum + 1; // One's complement and add one for checksum
        end else begin
            sum = sum + data; // Accumulate sum of data
        end
    end
endmodule