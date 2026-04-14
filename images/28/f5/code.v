module packet_filter(  
    input [31:0] src_ip,  
    input [7:0] port,  
    output reg allowed  
);  
    // Define allowed source IP and port  
    parameter ALLOWED_IP = 32'hC0A80101; // 192.168.1.1  
    parameter ALLOWED_PORT = 8'd80;      // Port 80  

    always @(*) begin  
        if (src_ip == ALLOWED_IP && port == ALLOWED_PORT)  
            allowed = 1;  
        else  
            allowed = 0;  
    end  
endmodule