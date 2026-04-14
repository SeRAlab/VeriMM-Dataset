module packet_filter (
    input [31:0] src_ip,
    input [31:0] dest_ip,
    input [7:0] protocol,
    output reg allow
);

always @(*) begin
    // Rule 1: Allow packets from 192.168.1.1 to any destination IP with TCP (protocol 6)
    if (src_ip == 32'hC0A80101 && protocol == 8'h06) begin
        allow = 1'b1; // Allow
    // Rule 2: Deny packets from 10.0.0.1 to 172.16.0.1 with any protocol
    end else if (src_ip == 32'h0A000001 && dest_ip == 32'hAC100001) begin
        allow = 1'b0; // Deny
    // Rule 3: Allow all other packets
    end else begin
        allow = 1'b1; // Allow
    end
end

endmodule