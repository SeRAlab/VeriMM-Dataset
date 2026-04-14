module nat_pat(  
    input clk,  
    input reset,  
    input [31:0] internal_ip,  
    input [15:0] internal_port,  
    output reg [31:0] external_ip,  
    output reg [15:0] external_port  
);  

    reg [15:0] next_port;  
    reg [15:0] base_port = 16'hC000; // Base port for PAT (49152 in decimal)  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            external_ip <= 32'hC0A80001; // Fixed external IP (192.168.0.1)  
            next_port <= base_port;  
        end else begin  
            external_ip <= 32'hC0A80001;  
            external_port <= next_port;  
            next_port <= next_port + 1; // Increment port for next translation  
        end  
    end  
endmodule