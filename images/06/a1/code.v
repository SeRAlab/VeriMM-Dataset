module thermal_sensor_calibration (
    input clk,
    input reset,
    input [9:0] sensor_input,
    input [7:0] calibration_value,
    output reg [9:0] calibrated_output
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            calibrated_output <= 10'b0;
        end else begin
            calibrated_output <= sensor_input + {2'b00, calibration_value}; // Adjusting by adding the calibration value
        end
    end
endmodule