module ThermalSensorCalibrator (
    input [9:0] raw_input,
    input [3:0] gain,
    input [5:0] offset,
    output [11:0] calibrated_output
);
    assign calibrated_output = (raw_input * gain) + offset;
endmodule