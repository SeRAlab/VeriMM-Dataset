module thermal_sensor_calibration (
    input wire clk,
    input wire enable,
    input wire [11:0] raw_temp,    // 12-bit raw temperature reading
    input wire [3:0] cal_factor,    // 4-bit calibration factor
    output reg [11:0] calibrated_temp // 12-bit calibrated temperature output
);

    always @(posedge clk) begin
        if (enable) begin
            calibrated_temp <= raw_temp + cal_factor;
        end
    end
endmodule