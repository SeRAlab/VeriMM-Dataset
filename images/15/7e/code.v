module packet_filter (
    input [31:0] source_ip,
    input allow_ip,
    output reg packet_allowed
);
    always @(*) begin
        if (allow_ip) begin
            // Define allowed IP addresses (e.g., 192.168.1.1, 10.0.0.1)
            if (source_ip == 32'hC0A80101 || source_ip == 32'h0A000001) // 192.168.1.1 or 10.0.0.1
                packet_allowed = 1'b1;
            else
                packet_allowed = 1'b0;
        end else begin
            packet_allowed = 1'b0; // If not allowed, packet is not permitted.
        end
    end
endmodule