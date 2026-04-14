module packet_filter (
    input [31:0] src_ip,
    input [31:0] dest_ip,
    input [3:0] protocol,
    input enable,
    output reg allowed
);

always @(*) begin
    if (!enable) begin
        allowed = 1'b1; // If filtering is disabled, allow all packets
    end else begin
        case (protocol)
            4'd6: // TCP
                if (src_ip == 32'hC0A80101) // 192.168.1.1
                    allowed = 1'b1; // Allow
                else
                    allowed = 1'b0; // Deny
            4'd17: // UDP
                if (src_ip == 32'h0A000001) // 10.0.0.1
                    allowed = 1'b0; // Deny
                else
                    allowed = 1'b1; // Allow
            default: 
                allowed = 1'b1; // Allow all other protocols
        endcase
    end
end

endmodule