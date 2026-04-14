module dvfs_controller (  
    input wire clk,  
    input wire reset,  
    input wire [1:0] load, // 00: Low, 01: Medium, 10: High  
    output reg [1:0] voltage_level, // 00: Low, 01: Medium, 10: High  
    output reg [1:0] frequency_level // 00: Low, 01: Medium, 10: High  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            voltage_level <= 2'b00;  
            frequency_level <= 2'b00;  
        end else begin  
            case (load)  
                2'b00: begin // Low load  
                    voltage_level <= 2'b00; // Low Voltage  
                    frequency_level <= 2'b00; // Low Frequency  
                end  
                2'b01: begin // Medium load  
                    voltage_level <= 2'b01; // Medium Voltage  
                    frequency_level <= 2'b01; // Medium Frequency  
                end  
                2'b10: begin // High load  
                    voltage_level <= 2'b10; // High Voltage  
                    frequency_level <= 2'b10; // High Frequency  
                end  
                default: begin  
                    voltage_level <= 2'b00;  
                    frequency_level <= 2'b00;  
                end  
            endcase  
        end  
    end  
endmodule