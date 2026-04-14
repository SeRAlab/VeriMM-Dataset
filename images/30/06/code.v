module dvfs_controller(
    input clk,
    input reset,
    input [3:0] voltage_level, // 0 to 15
    input [3:0] frequency_level, // 0 to 15
    output reg control_signal // 1 for scale up, 0 for scale down
);
    
    parameter THRESHOLD_VOLTAGE_UP = 10;
    parameter THRESHOLD_VOLTAGE_DOWN = 5;
    parameter THRESHOLD_FREQUENCY_UP = 10;
    parameter THRESHOLD_FREQUENCY_DOWN = 5;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            control_signal <= 0; // Default to scale down
        end else begin
            if (voltage_level > THRESHOLD_VOLTAGE_UP || frequency_level > THRESHOLD_FREQUENCY_UP) begin
                control_signal <= 1; // Scale up
            end else if (voltage_level < THRESHOLD_VOLTAGE_DOWN || frequency_level < THRESHOLD_FREQUENCY_DOWN) begin
                control_signal <= 0; // Scale down
            end
        end
    end
endmodule