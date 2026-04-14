module packet_filter (  
    input [31:0] packet_ip,  
    input [31:0] allowed_ip,  
    output reg allowed  
);  
    always @(*) begin  
        if (packet_ip == allowed_ip)  
            allowed = 1'b1;  
        else  
            allowed = 1'b0;  
    end  
endmodule