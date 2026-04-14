module thermal_sensor_calibration (
    input wire clk,
    input wire reset,
    input wire load_offset,
    input wire [9:0] offset_value,
    input wire start_calibration,
    input wire [9:0] raw_reading,
    output reg [9:0] calibrated_value
);
    reg [9:0] offset;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            offset <= 10'b0;
            calibrated_value <= 10'b0;
        end else if (load_offset) begin
            offset <= offset_value;
        end else if (start_calibration) begin
            calibrated_value <= raw_reading + offset;
        end
    end
endmodule