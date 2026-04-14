module ip_checksum (
    input [15:0] data_in,
    input valid,
    output reg [15:0] checksum
);
    reg [15:0] sum;
    always @(*) begin
        if (valid) begin
            sum = data_in; // Initialize sum with the first word
            checksum = ~sum; // One's complement
        end else begin
            checksum = 16'hFFFF; // Invalid case, return all ones
        end
    end
endmodule