module nat (  
    input wire clk,  
    input wire reset,  
    input wire [31:0] src_ip,  
    input wire [31:0] dest_ip,  
    output reg [31:0] nat_ip  
);  
    reg [31:0] nat_addr;  

    always @(posedge clk or posedge reset) begin  
        if (reset)  
            nat_addr <= 32'hC0A80101; // Example NAT address: 192.168.1.1  
        else  
            nat_addr <= src_ip;  
    end  

    always @(posedge clk) begin  
        nat_ip <= nat_addr;  
    end  
endmodule