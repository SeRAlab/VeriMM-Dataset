module packet_filter (
    input wire [31:0] src_ip,
    input wire allow,
    output reg packet_status
);
    
    always @(*) begin
        if (allow) 
            packet_status = 1'b1; // Packet is allowed
        else 
            packet_status = 1'b0; // Packet is blocked
    end
    
endmodule