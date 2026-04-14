module ip_checksum (
    input [15:0] data_in,
    input valid,
    output reg [15:0] checksum,
    output reg ready
);
    reg [31:0] sum; // To hold the sum with carry

    always @(*) begin
        if (valid) begin
            sum = data_in; // Initialize sum with the first word
            ready = 0; // Not ready until we calculate
        end else begin
            sum = sum + data_in; // Add incoming data
            sum = (sum >> 16) + (sum & 16'hFFFF); // Add upper and lower parts
            checksum = ~sum[15:0]; // One's complement
            ready = 1; // Indicate ready after calculation
        end
    end
endmodule