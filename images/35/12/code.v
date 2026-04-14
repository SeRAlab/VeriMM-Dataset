module DVFS_Controller(
    input clk,
    input reset,
    input [7:0] temperature, // 0 to 100 degrees
    input [7:0] workload,    // 0 to 100 percent
    output reg [1:0] voltage_level, // 0: 0.8V, 1: 1.0V, 2: 1.2V
    output reg [1:0] frequency_level // 0: 1GHz, 1: 2GHz, 2: 3GHz
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            voltage_level <= 1; // Default to 1.0V
            frequency_level <= 1; // Default to 2GHz
        end else begin
            if (temperature < 50) begin
                voltage_level <= 0; // 0.8V
                frequency_level <= 0; // 1GHz
            end else if (temperature < 75) begin
                voltage_level <= 1; // 1.0V
                frequency_level <= 1; // 2GHz
            end else begin
                voltage_level <= 2; // 1.2V
                frequency_level <= 2; // 3GHz
            end
            
            if (workload < 50) begin
                frequency_level <= frequency_level - 1; // Reduce frequency
            end else if (workload > 75) begin
                frequency_level <= frequency_level + 1; // Increase frequency
            end
        end
    end
endmodule