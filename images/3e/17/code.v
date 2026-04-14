module packet_filter (
    input [31:0] src_ip,
    input [31:0] dest_ip,
    input [7:0] protocol,
    output reg accept
);
    
    // Define allowed criteria
    parameter [31:0] ALLOWED_SRC_IP = 32'hC0A80001; // 192.168.0.1
    parameter [31:0] ALLOWED_DEST_IP = 32'hC0A80002; // 192.168.0.2
    parameter [7:0] ALLOWED_PROTOCOL = 8'h06; // TCP
    
    always @(*) begin
        // Check if the packet meets the criteria
        if (src_ip == ALLOWED_SRC_IP && dest_ip == ALLOWED_DEST_IP && protocol == ALLOWED_PROTOCOL) 
            accept = 1'b1; // Accept the packet
        else 
            accept = 1'b0; // Reject the packet
    end
endmodule