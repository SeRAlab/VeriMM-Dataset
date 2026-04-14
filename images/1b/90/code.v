module packet_filter(  
    input [7:0] src_ip,  
    input [7:0] allowed_ip,  
    output reg allow  
);  
    always @(*) begin  
        if (src_ip == allowed_ip)  
            allow = 1;  
        else  
            allow = 0;  
    end  
endmodule