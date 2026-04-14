module thermal_sensor_calibration (
    input wire clk,
    input wire reset,
    input wire [11:0] raw_temperature,
    input wire [11:0] gain,
    input wire [11:0] offset,
    input wire update_coefficients,
    output reg [11:0] calibrated_temperature
);

reg [11:0] current_gain;
reg [11:0] current_offset;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        current_gain <= 12'd0;
        current_offset <= 12'd0;
        calibrated_temperature <= 12'd0;
    end else begin
        if (update_coefficients) begin
            current_gain <= gain;
            current_offset <= offset;
        end
        calibrated_temperature <= (raw_temperature * current_gain) + current_offset;
    end
end

endmodule