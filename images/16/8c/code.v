module ip_checksum (
    input [15:0] data_in,
    input valid,
    output reg [15:0] checksum_out
);
    reg [31:0] sum;
    integer i;

    always @(*) begin
        sum = 0;
        if (valid) begin
            sum = sum + data_in;
            for (i = 1; i < 5; i = i + 1) begin
                sum = sum + data_in; // Simulated multiple data inputs
            end
            checksum_out = ~sum[15:0]; // One's complement
        end else begin
            checksum_out = 16'hFFFF; // Default output when not valid
        end
    end
endmodule