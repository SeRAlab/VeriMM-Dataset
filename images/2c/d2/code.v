module packet_filter (
    input [31:0] src_ip,
    input [31:0] dest_ip,
    input flag, // 1 for SYN, 0 for not SYN
    output reg allowed
);
    parameter BLOCKED_IP = 32'hC0A80001; // Example blocked IP: 192.168.0.1

    always @(*) begin
        if (src_ip == BLOCKED_IP) begin
            allowed = 0; // Blocked
        end else if (flag == 1) begin
            allowed = 1; // Allowed if it is SYN and not from blocked IP
        end else begin
            allowed = 1; // Allowed otherwise
        end
    end
endmodule