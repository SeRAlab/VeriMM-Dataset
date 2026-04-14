module ip_checksum (
    input [15:0] data_in,
    input end_of_data,
    output reg [15:0] checksum
);
    reg [15:0] sum;

    always @(posedge end_of_data) begin
        sum = sum + data_in; // Add data_in to the sum
        checksum = ~sum;      // One's complement of the sum
    end
    
    initial begin
        sum = 16'h0000; // Initialize sum to 0
        checksum = 16'h0000; // Initialize checksum
    end
endmodule