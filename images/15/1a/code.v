module packet_filter (  
    input [7:0] src_ip, // 8-bit source IP  
    input [15:0] dest_port, // 16-bit destination port  
    output reg allowed // 1-bit output for allowed/blocked  
);  

    // Define allowed range and ports  
    parameter ALLOWED_IP_START = 8'h0A; // 10.0.0.0  
    parameter ALLOWED_IP_END = 8'h0A;   // 10.0.0.255  
    parameter ALLOWED_PORT_1 = 16'h0035; // Port 53  
    parameter ALLOWED_PORT_2 = 16'h1F90; // Port 8080  

    always @(*) begin  
        if ((src_ip >= ALLOWED_IP_START && src_ip <= ALLOWED_IP_END) &&  
            (dest_port == ALLOWED_PORT_1 || dest_port == ALLOWED_PORT_2))  
            allowed = 1; // Packet allowed  
        else  
            allowed = 0; // Packet blocked  
    end  
endmodule