module packet_filter(  
    input wire clk,  
    input wire rst,  
    input wire enable,  
    input wire bypass,  
    input wire [15:0] packet_in,  
    output reg [15:0] packet_out,  
    output reg deny  
);  
    parameter BLOCKED_PATTERN = 16'hABCD;  
    
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            packet_out <= 16'b0;  
            deny <= 1'b0;  
        end else if (bypass) begin  
            packet_out <= packet_in;  
            deny <= 1'b0;  
        end else if (enable) begin  
            if (packet_in == BLOCKED_PATTERN) begin  
                packet_out <= 16'b0;  
                deny <= 1'b1;  
            end else begin  
                packet_out <= packet_in;  
                deny <= 1'b0;  
            end  
        end else begin  
            packet_out <= packet_in;  
            deny <= 1'b0;  
        end  
    end  
endmodule