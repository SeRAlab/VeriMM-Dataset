module packet_filter(
    input [15:0] src_ip,
    input [15:0] dest_ip,
    input [15:0] rule_src_0,
    input [15:0] rule_dest_0,
    input [15:0] rule_src_1,
    input [15:0] rule_dest_1,
    input [15:0] rule_src_2,
    input [15:0] rule_dest_2,
    input [15:0] rule_src_3,
    input [15:0] rule_dest_3,
    output reg allow
);
    
    always @(*) begin
        allow = 0; // default to blocked
        if ((src_ip == rule_src_0 && dest_ip == rule_dest_0) ||
            (src_ip == rule_src_1 && dest_ip == rule_dest_1) ||
            (src_ip == rule_src_2 && dest_ip == rule_dest_2) ||
            (src_ip == rule_src_3 && dest_ip == rule_dest_3)) begin
            allow = 1; // packet allowed
        end
    end
    
endmodule