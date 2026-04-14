module nat_mapping(  
    input [31:0] private_ip,  
    output reg [31:0] public_ip  
);  

always @(*) begin  
    case (private_ip)  
        32'hC0A80001: public_ip = 32'h1A2B3C4D; // 192.168.0.1 to 26.43.60.77  
        32'hC0A80002: public_ip = 32'h1A2B3C4E; // 192.168.0.2 to 26.43.60.78  
        32'hC0A80003: public_ip = 32'h1A2B3C4F; // 192.168.0.3 to 26.43.60.79  
        32'hC0A80004: public_ip = 32'h1A2B3C50; // 192.168.0.4 to 26.43.60.80  
        default: public_ip = 32'hFFFFFFFF; // Unknown IP  
    endcase  
end  
endmodule