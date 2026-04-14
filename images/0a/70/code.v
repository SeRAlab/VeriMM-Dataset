module packet_filter(  
    input [31:0] src_ip,  
    input [15:0] dest_port,  
    output reg [7:0] action  
);  
    // Define allowed IP and port  
    parameter ALLOWED_IP = 32'hC0A80001; // 192.168.0.1  
    parameter ALLOWED_PORT = 16'h00AF; // 175  

    always @(*) begin  
        if (src_ip == ALLOWED_IP && dest_port == ALLOWED_PORT)  
            action = 8'h61; // 'a' for allow  
        else  
            action = 8'h64; // 'd' for deny  
    end  
endmodule