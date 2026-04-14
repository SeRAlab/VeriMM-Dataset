module packet_filter (
    input wire [31:0] src_ip,
    input wire [31:0] dst_ip,
    input wire allow_control,
    output wire packet_allowed
);
    // Predefined allowed IP addresses
    localparam [31:0] ALLOWED_IP1 = 32'hC0A80001; // 192.168.0.1
    localparam [31:0] ALLOWED_IP2 = 32'hC0A80002; // 192.168.0.2
    localparam [31:0] ALLOWED_IP3 = 32'hC0A80003; // 192.168.0.3

    assign packet_allowed = (allow_control && 
                            (src_ip == ALLOWED_IP1 || 
                             src_ip == ALLOWED_IP2 || 
                             src_ip == ALLOWED_IP3));
endmodule