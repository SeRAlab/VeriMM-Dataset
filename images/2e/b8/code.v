module ip_checksum(
    input [15:0] data_in,
    output reg [15:0] checksum_out
);
    reg [15:0] sum;
    
    always @(*) begin
        sum = 16'b0; // Initialize sum
        sum = sum + data_in; // Add the input data
        checksum_out = ~sum; // One's complement of the sum
    end
endmodule