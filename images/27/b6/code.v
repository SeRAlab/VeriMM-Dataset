module packet_filter (
    input wire [31:0] src_ip,      // Source IP address
    input wire [31:0] dest_ip,     // Destination IP address
    input wire allow_control,       // Control signal (1 = allow; 0 = deny)
    output wire packet_allowed       // Output signal (1 = allowed; 0 = denied)
);
    
    // Allow list for source IPs
    parameter ALLOW_IP1 = 32'hC0A80001; // 192.168.0.1
    parameter ALLOW_IP2 = 32'hC0A80002; // 192.168.0.2
    
    assign packet_allowed = (allow_control && (src_ip == ALLOW_IP1 || src_ip == ALLOW_IP2)) ? 1'b1 : 1'b0;

endmodule