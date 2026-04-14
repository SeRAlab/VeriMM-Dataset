module packet_filter(  
    input [31:0] src_ip,  
    input [15:0] dest_port,  
    output reg valid  
);  
    parameter PREDEFINED_IP = 32'hC0A80001; // 192.168.0.1  
    always @* begin  
        if (src_ip == PREDEFINED_IP && (dest_port == 16'd80 || dest_port == 16'd443))  
            valid = 1;  
        else  
            valid = 0;  
    end  
endmodule