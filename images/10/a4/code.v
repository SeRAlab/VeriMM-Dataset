module nat_device(  
    input [31:0] private_ip,  
    input [15:0] private_port,  
    output reg [31:0] public_ip,  
    output reg [15:0] public_port  
);  
    always @(*) begin  
        if (private_ip == 32'hC0A8010A && private_port == 16'd8080) begin // 192.168.1.10  
            public_ip = 32'hCB007B05; // 203.0.113.5  
            public_port = 16'd80;  
        end else begin  
            public_ip = private_ip;  
            public_port = private_port;  
        end  
    end  
endmodule