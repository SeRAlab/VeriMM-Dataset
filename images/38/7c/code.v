module nat_translation(  
    input [31:0] internal_ip,  
    output reg [31:0] external_ip  
);  
    always @(*) begin  
        case (internal_ip)  
            32'hC0A80001: external_ip = 32'h7F000001; // 192.168.0.1 -> 127.0.0.1  
            32'hC0A80002: external_ip = 32'h7F000002; // 192.168.0.2 -> 127.0.0.2  
            32'hC0A80003: external_ip = 32'h7F000003; // 192.168.0.3 -> 127.0.0.3  
            32'hC0A80004: external_ip = 32'h7F000004; // 192.168.0.4 -> 127.0.0.4  
            32'hC0A80005: external_ip = 32'h7F000005; // 192.168.0.5 -> 127.0.0.5  
            default: external_ip = 32'h00000000; // Not found  
        endcase  
    end  
endmodule