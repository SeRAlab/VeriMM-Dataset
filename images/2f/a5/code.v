module packet_filter (
    input [15:0] packet,
    input [3:0] filter_mask,
    output reg allowed
);
    parameter ALLOWED_VALUE = 16'b1010101010101010; // Example allowed packet value

    always @(*) begin
        // Apply the filter mask to the packet
        if ((packet & {4'b0000, filter_mask}) == ALLOWED_VALUE) begin
            allowed = 1'b1; // Packet is allowed
        end else begin
            allowed = 1'b0; // Packet is blocked
        end
    end
endmodule