module ip_checksum (
    input [15:0] data_in,
    input valid,
    output reg [15:0] checksum
);
    reg [31:0] sum;
    
    always @(*) begin
        if (valid) begin
            // Initialize sum
            sum = 16'h0;
            // Compute checksum
            sum = sum + data_in;
            // Take one's complement
            checksum = ~sum[15:0];
        end else begin
            checksum = 16'h0; // Default output when not valid
        end
    end
endmodule