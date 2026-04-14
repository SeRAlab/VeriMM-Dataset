module nat_translation(  
    input [31:0] private_ip,  
    output reg [31:0] public_ip  
);  
    always @(*) begin  
        case(private_ip)  
            32'hC0A80001: public_ip = 32'h7F000001; // 192.168.0.1 -> 127.0.0.1  
            32'hC0A80002: public_ip = 32'h7F000002; // 192.168.0.2 -> 127.0.0.2  
            32'hC0A80003: public_ip = 32'h7F000003; // 192.168.0.3 -> 127.0.0.3  
            32'hC0A80004: public_ip = 32'h7F000004; // 192.168.0.4 -> 127.0.0.4  
            default: public_ip = 32'h00000000; // Default IP  
        endcase  
    end  
endmodule