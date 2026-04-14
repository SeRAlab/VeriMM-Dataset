module thermal_sensor_calibration (
    input wire clk,
    input wire reset,
    input wire load_coeff,
    input wire [15:0] raw_temp,
    input wire [15:0] coeff_a,
    input wire [15:0] coeff_b,
    output reg [15:0] calibrated_temp
);
    reg [15:0] a, b;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            calibrated_temp <= 16'h0000;
            a <= 16'h0000;
            b <= 16'h0000;
        end else if (load_coeff) begin
            a <= coeff_a;
            b <= coeff_b;
        end else begin
            calibrated_temp <= (raw_temp * a) + b;
        end
    end
endmodule