module thermal_sensor_calibration (
    input clk,
    input rst,
    input [9:0] temperature_input,
    input [3:0] calibration_factor,
    output reg [9:0] calibrated_temperature
);
    
    reg [9:0] current_temperature;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            current_temperature <= 10'b0;
            calibrated_temperature <= 10'b0;
        end else begin
            current_temperature <= temperature_input + {{6{calibration_factor[3]}}, calibration_factor}; // Sign-extend calibration factor
            if (current_temperature > 10'd1023) begin
                calibrated_temperature <= 10'd1023; // Clamp to maximum
            end else begin
                calibrated_temperature <= current_temperature;
            end
        end
    end
endmodule