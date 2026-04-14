module ip_checksum (
    input [15:0] data_in,
    output reg [15:0] checksum_out
);
    reg [15:0] sum;
    always @(*) begin
        sum = data_in + 16'h0; // Initialize sum with data_in
        checksum_out = ~sum; // One's complement
    end
endmodule