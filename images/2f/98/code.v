module thermal_sensor_calibration (
    input wire clk,
    input wire reset,
    input wire [7:0] raw_temp,
    input wire [7:0] calibration_value,
    output reg [7:0] calibrated_temp
);
    reg [7:0] temp_readings [0:4];
    reg [3:0] count;
    reg [15:0] sum;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            calibrated_temp <= 0;
            count <= 0;
            sum <= 0;
        end else begin
            // Shift the readings
            sum <= sum - temp_readings[count] + raw_temp;
            temp_readings[count] <= raw_temp;

            // Update the calibrated temperature
            calibrated_temp <= (sum + (calibration_value * 5)) / 5;

            // Update the index
            count <= (count + 1) % 5;
        end
    end
endmodule