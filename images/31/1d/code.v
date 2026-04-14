module packet_filter (
    input [31:0] packet_ip,
    input [31:0] allowed_ip_0,
    input [31:0] allowed_ip_1,
    input [31:0] allowed_ip_2,
    input [31:0] allowed_ip_3,
    output reg allowed
);
    always @(*) begin
        allowed = (packet_ip == allowed_ip_0) || 
                  (packet_ip == allowed_ip_1) || 
                  (packet_ip == allowed_ip_2) || 
                  (packet_ip == allowed_ip_3);
    end
endmodule