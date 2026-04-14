module packet_filter (
    input [15:0] packet,
    input [3:0] filter,
    output reg allow
);
    always @(*) begin
        // Check if the protocol matches the filter
        if (filter[3:2] == packet[15:14] && filter[1:0] == packet[1:0]) begin
            allow = 1'b1; // Allow the packet
        end else begin
            allow = 1'b0; // Block the packet
        end
    end
endmodule