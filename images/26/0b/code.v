module nat_translator(  
    input clk,  
    input rst,  
    input [31:0] internal_ip,  
    input [15:0] internal_port,  
    output reg [31:0] public_ip,  
    output reg [15:0] public_port  
);  

    reg [31:0] ip_mapping [0:4];  
    reg [15:0] port_mapping [0:4];  
    reg [2:0] index;  

    initial begin  
        // Example mappings  
        ip_mapping[0] = 32'hC0A80001; // 192.168.0.1  
        port_mapping[0] = 16'h1F90;   // 8080  
        ip_mapping[1] = 32'hC0A80002; // 192.168.0.2  
        port_mapping[1] = 16'h1F91;   // 8081  
        ip_mapping[2] = 32'hC0A80003; // 192.168.0.3  
        port_mapping[2] = 16'h1F92;   // 8082  
        ip_mapping[3] = 32'hC0A80004; // 192.168.0.4  
        port_mapping[3] = 16'h1F93;   // 8083  
        ip_mapping[4] = 32'hC0A80005; // 192.168.0.5  
        port_mapping[4] = 16'h1F94;   // 8084  
    end  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            public_ip <= 32'h00000000;  
            public_port <= 16'h0000;  
            index <= 3'b000;  
        end else begin  
            public_ip <= 32'h00000000;  
            public_port <= 16'h0000;  
            index <= 3'b000;  
            for (index = 0; index < 5; index = index + 1) begin  
                if (internal_ip == ip_mapping[index] && internal_port == port_mapping[index]) begin  
                    public_ip <= 32'hAABBCCDD; // Example public IP  
                    public_port <= 16'h1F90 + index; // Example public ports  
                end  
            end  
        end  
    end  
endmodule