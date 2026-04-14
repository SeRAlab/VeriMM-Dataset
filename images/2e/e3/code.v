module thermal_sensor_calibration(
    input wire clk,
    input wire enable,
    input wire [3:0] sensor_value,
    input wire [3:0] calibration_factor,
    output reg [3:0] calibrated_output
);
    reg [3:0] current_output;

    always @(posedge clk) begin
        if (enable) begin
            current_output <= sensor_value + calibration_factor;
        end
        calibrated_output <= current_output;
    end
endmodule