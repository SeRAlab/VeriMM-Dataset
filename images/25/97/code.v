module DVFS_Controller(  
    input clk,  
    input rst_n,  
    input [1:0] load, // 00: Low, 01: Medium, 10: High  
    output reg [1:0] voltage_level, // 00: Low Voltage, 01: Medium Voltage, 10: High Voltage  
    output reg [1:0] frequency_level // 00: Low Frequency, 01: Medium Frequency, 10: High Frequency  
);  
    always @(posedge clk or negedge rst_n) begin  
        if (!rst_n) begin  
            voltage_level <= 2'b00;  
            frequency_level <= 2'b00;  
        end else begin  
            case (load)  
                2'b00: begin // Low Load  
                    voltage_level <= 2'b00;  
                    frequency_level <= 2'b00;  
                end  
                2'b01: begin // Medium Load  
                    voltage_level <= 2'b01;  
                    frequency_level <= 2'b01;  
                end  
                2'b10: begin // High Load  
                    voltage_level <= 2'b10;  
                    frequency_level <= 2'b10;  
                end  
                default: begin  
                    voltage_level <= 2'b00;  
                    frequency_level <= 2'b00;  
                end  
            endcase  
        end  
    end  
endmodule