module NAT (  
    input wire clk,  
    input wire rst,  
    input wire enable,  
    input wire [31:0] src_ip,  
    input wire [15:0] src_port,  
    output reg [31:0] translated_ip,  
    output reg [15:0] translated_port,  
    output reg valid  
);  

    // Example static mapping for NAT  
    reg [31:0] nat_table [0:4];    
    reg [15:0] port_table [0:4];    
    initial begin  
        nat_table[0] = 32'hC0A80001; // 192.168.0.1  
        nat_table[1] = 32'hC0A80002; // 192.168.0.2  
        nat_table[2] = 32'hC0A80003; // 192.168.0.3  
        nat_table[3] = 32'hC0A80004; // 192.168.0.4  
        nat_table[4] = 32'hC0A80005; // 192.168.0.5  
        port_table[0] = 16'h1F90; // 8080  
        port_table[1] = 16'h1F91; // 8081  
        port_table[2] = 16'h1F92; // 8082  
        port_table[3] = 16'h1F93; // 8083  
        port_table[4] = 16'h1F94; // 8084  
    end  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            translated_ip <= 32'b0;  
            translated_port <= 16'b0;  
            valid <= 1'b0;  
        end else if (enable) begin  
            valid <= 1'b1;  
            // Simple mapping based on index  
            if (src_port < 5) begin  
                translated_ip <= nat_table[src_port];  
                translated_port <= port_table[src_port];  
            end else begin  
                translated_ip <= 32'b0;  
                translated_port <= 16'b0;  
            end  
        end else begin  
            valid <= 1'b0;  
        end  
    end  
endmodule