module packet_filtering_firewall(  
    input clk,  
    input reset,  
    input [31:0] src_ip,  
    input [31:0] dest_ip,  
    input [2:0] protocol, // 0: TCP, 1: UDP, 2: ICMP, etc.  
    input [4:0] rule_enable, // Each bit enables a rule  
    output reg action // 1: allow, 0: deny  
);  
    reg [31:0] rule_src_ip [0:4];  
    reg [31:0] rule_dest_ip [0:4];  
    reg [2:0] rule_protocol [0:4];  
    
    integer i;  
    initial begin  
        // Initialize rules (example rules)  
        rule_src_ip[0] = 32'hC0A80001; // 192.168.0.1  
        rule_dest_ip[0] = 32'hC0A80002; // 192.168.0.2  
        rule_protocol[0] = 3'd0; // TCP  
        
        rule_src_ip[1] = 32'hC0A80003; // 192.168.0.3  
        rule_dest_ip[1] = 32'hC0A80004; // 192.168.0.4  
        rule_protocol[1] = 3'd1; // UDP
        
        // Initialize other rules as needed  
        // rule_src_ip[2...4], rule_dest_ip[2...4], rule_protocol[2...4]  
    end  
    
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            action <= 0;  
        end else begin  
            action <= 0; // Default deny  
            for (i = 0; i < 5; i = i + 1) begin  
                if (rule_enable[i]) begin  
                    if (src_ip == rule_src_ip[i] && dest_ip == rule_dest_ip[i] && protocol == rule_protocol[i]) begin  
                        action <= 1; // Allow packet  
                    end  
                end  
            end  
        end  
    end  
endmodule