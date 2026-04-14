module nat_translation(  
    input [31:0] private_ip,  
    output reg [31:0] public_ip  
);  
    always @(*) begin  
        case(private_ip)  
            32'hC0A80001: public_ip = 32'hAABBCC01; // 192.168.0.1 -> 170.187.204.1  
            32'hC0A80002: public_ip = 32'hAABBCC02; // 192.168.0.2 -> 170.187.204.2  
            32'hC0A80003: public_ip = 32'hAABBCC03; // 192.168.0.3 -> 170.187.204.3  
            32'hC0A80004: public_ip = 32'hAABBCC04; // 192.168.0.4 -> 170.187.204.4  
            default: public_ip = 32'h00000000; // Default public IP is 0.0.0.0  
        endcase  
    end  
endmodule