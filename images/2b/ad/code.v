module packet_filter (
    input wire [31:0] packet_ip,
    input wire [31:0] allowed_ip_1,
    input wire [31:0] allowed_ip_2,
    input wire [31:0] allowed_ip_3,
    input wire [31:0] allowed_ip_4,
    output wire is_allowed
);
    assign is_allowed = (packet_ip == allowed_ip_1) || 
                        (packet_ip == allowed_ip_2) || 
                        (packet_ip == allowed_ip_3) || 
                        (packet_ip == allowed_ip_4);
endmodule