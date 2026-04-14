module packet_filter(  
    input [7:0] src_ip,  
    input [7:0] dest_ip,  
    input [7:0] protocol,  
    output reg allow  
);  

always @(*) begin  
    if ((src_ip == 8'hC0) && (dest_ip == 8'hC0) && (protocol == 8'h06)) // 192.168.1.1 to 192.168.1.2 for TCP  
        allow = 1'b1;  
    else if ((src_ip == 8'h0A) && (dest_ip == 8'h0A) && (protocol == 8'h11)) // 10.0.0.1 to 10.0.0.2 for UDP  
        allow = 1'b1;  
    else  
        allow = 1'b0;  
end  
endmodule