module thermal_sensor_calibration (
    input wire clk,
    input wire rst,
    input wire [7:0] temp_in,
    output reg [7:0] calibrated_temp
);
    reg [7:0] temp_samples [0:2];
    reg [1:0] sample_count;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            temp_samples[0] <= 8'd0;
            temp_samples[1] <= 8'd0;
            temp_samples[2] <= 8'd0;
            sample_count <= 2'b00;
            calibrated_temp <= 8'd0;
        end else begin
            temp_samples[sample_count] <= temp_in;
            sample_count <= (sample_count + 1) % 3;

            calibrated_temp <= (temp_samples[0] + temp_samples[1] + temp_samples[2]) / 3;
        end
    end
endmodule