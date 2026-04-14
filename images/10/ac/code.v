module DVFS_Controller (  
    input clk,  
    input [7:0] temperature,  
    output reg [3:0] voltage,  
    output reg [3:0] frequency  
);  
    always @(posedge clk) begin  
        if (temperature < 8'd20) begin  
            voltage <= 4'b0001; // 1V  
            frequency <= 4'b0001; // 1GHz  
        end else if (temperature < 8'd40) begin  
            voltage <= 4'b0010; // 2V  
            frequency <= 4'b0010; // 2GHz  
        end else if (temperature < 8'd60) begin  
            voltage <= 4'b0011; // 3V  
            frequency <= 4'b0011; // 3GHz  
        end else begin  
            voltage <= 4'b0100; // 4V  
            frequency <= 4'b0100; // 4GHz  
        end  
    end  
endmodule