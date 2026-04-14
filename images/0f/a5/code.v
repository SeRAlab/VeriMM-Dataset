module ip_checksum (
    input [15:0] data_in,
    output reg [15:0] checksum_out
);
    reg [15:0] sum;
    integer i;

    always @(*) begin
        sum = 16'h0000;
        // In a real scenario, this would be done in a loop
        sum = sum + data_in;
        checksum_out = ~sum; // One's complement
    end
endmodule