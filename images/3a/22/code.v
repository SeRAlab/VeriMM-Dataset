module ThermalSensorCalibration (
    input wire [7:0] raw_temp,
    input wire [7:0] calibration_value,
    input wire calibrate,
    output reg [7:0] calibrated_temp
);
    always @(posedge calibrate) begin
        calibrated_temp <= raw_temp + calibration_value;
    end
endmodule