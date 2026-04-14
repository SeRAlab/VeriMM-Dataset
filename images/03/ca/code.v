module packet_filter (
    input [31:0] src_ip,
    input [31:0] dst_ip,
    input [7:0] protocol,
    output reg action
);

// Predefined IP addresses and protocol for acceptance
parameter [31:0] ACCEPT_SRC_IP = 32'hC0A80001; // 192.168.0.1
parameter [31:0] ACCEPT_DST_IP = 32'hC0A80002; // 192.168.0.2
parameter [7:0] ACCEPT_PROTOCOL = 8'h06; // TCP

always @(*) begin
    if (src_ip == ACCEPT_SRC_IP && dst_ip == ACCEPT_DST_IP && protocol == ACCEPT_PROTOCOL) begin
        action = 1'b1; // Accept
    end else begin
        action = 1'b0; // Reject
    end
end

endmodule