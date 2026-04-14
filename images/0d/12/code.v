module NAT_Converter(  
    input [31:0] private_ip,  
    output reg [31:0] public_ip  
);  

    always @(*) begin  
        case (private_ip)  
            32'hC0A80001: public_ip = 32'hA1B2C3D4; // 192.168.0.1 -> Public IP  
            32'hC0A80002: public_ip = 32'hA1B2C3D5; // 192.168.0.2 -> Public IP  
            32'hC0A80003: public_ip = 32'hA1B2C3D6; // 192.168.0.3 -> Public IP  
            32'hC0A80004: public_ip = 32'hA1B2C3D7; // 192.168.0.4 -> Public IP  
            32'hC0A80005: public_ip = 32'hA1B2C3D8; // 192.168.0.5 -> Public IP  
            default: public_ip = 32'hFFFFFFFF; // Unknown IP  
        endcase  
    end  
endmodule