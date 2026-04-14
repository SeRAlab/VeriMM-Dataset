module dvfs_controller(
    input clk,
    input enable,
    input [7:0] temperature,
    output reg [1:0] voltage_level,
    output reg [1:0] frequency_level
);
    
    always @(posedge clk) begin
        if (enable) begin
            if (temperature < 50) begin
                voltage_level <= 2'b00; // Low Voltage
                frequency_level <= 2'b00; // Low Frequency
            end else if (temperature < 75) begin
                voltage_level <= 2'b01; // Medium Voltage
                frequency_level <= 2'b01; // Medium Frequency
            end else if (temperature < 100) begin
                voltage_level <= 2'b10; // High Voltage
                frequency_level <= 2'b10; // High Frequency
            end else begin
                voltage_level <= 2'b11; // Maximum Voltage
                frequency_level <= 2'b11; // Maximum Frequency
            end
        end
    end
endmodule