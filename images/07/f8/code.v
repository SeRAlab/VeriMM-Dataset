module thermal_sensor_calibration (
    input wire [7:0] sensor_reading,
    input wire [3:0] calibration_factor,
    input wire clk,
    input wire rst,
    output reg [7:0] calibrated_reading
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            calibrated_reading <= 8'b0;
        end else begin
            calibrated_reading <= (sensor_reading + calibration_factor > 8'd255) ? 8'd255 : (sensor_reading + calibration_factor);
        end
    end
endmodule