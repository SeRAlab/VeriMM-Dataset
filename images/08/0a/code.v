module thermal_sensor_calibration (
    input wire clk,
    input wire [15:0] temp_input,
    input wire [7:0] calibration_factor,
    output reg [15:0] temp_output
);

always @(posedge clk) begin
    temp_output <= temp_input + calibration_factor;
end

endmodule