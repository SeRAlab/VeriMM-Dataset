module packet_filtering(  
    input [7:0] src_ip,  
    input [7:0] dest_ip,  
    input [2:0] protocol,  
    input [7:0] allowed_src_ip_1,  
    input [7:0] allowed_dest_ip_1,  
    input [2:0] allowed_protocol_1,  
    input [7:0] allowed_src_ip_2,  
    input [7:0] allowed_dest_ip_2,  
    input [2:0] allowed_protocol_2,  
    output reg allow  
);  

always @(*) begin  
    if ((src_ip == allowed_src_ip_1 && dest_ip == allowed_dest_ip_1 && protocol == allowed_protocol_1) ||  
        (src_ip == allowed_src_ip_2 && dest_ip == allowed_dest_ip_2 && protocol == allowed_protocol_2))  
        allow = 1;  
    else  
        allow = 0;  
end  
endmodule