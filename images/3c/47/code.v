module packet_filtering (  
    input [4:0] src_ip,  
    input [4:0] dest_ip,  
    output reg allowed  
);  
    always @(*) begin  
        if ((src_ip >= 5 && src_ip <= 10) && (dest_ip == 15))  
            allowed = 1;  
        else  
            allowed = 0;  
    end  
endmodule