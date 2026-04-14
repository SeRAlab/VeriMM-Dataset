module NAT_Translator (  
    input wire clk,  
    input wire reset,  
    input wire [7:0] internal_ip,  
    input wire request,  
    output reg [7:0] external_ip,  
    output reg ready  
);  
    reg [7:0] ip_mapping [0:255]; // IP translation mapping  
    initial begin  
        // Example mapping for internal to external IPs  
        ip_mapping[0] = 8'hC0; // 192  
        ip_mapping[1] = 8'hA8; // 168  
        ip_mapping[2] = 8'h01; // 1  
        // Add more mappings as required  
    end  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            external_ip <= 8'h00;  
            ready <= 1'b0;  
        end else if (request) begin  
            external_ip <= ip_mapping[internal_ip];  
            ready <= 1'b1;  
        end else begin  
            ready <= 1'b0;  
        end  
    end  
endmodule