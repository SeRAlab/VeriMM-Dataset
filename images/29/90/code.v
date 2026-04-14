module ThermalSensorCalibration (
    input wire clk,
    input wire reset,
    input wire enable,
    input wire [9:0] raw_temp,
    input wire [5:0] offset,
    output reg [9:0] calibrated_temp
);
    reg [3:0] state;
    reg [9:0] temp_sum;
    reg [3:0] cycle_count;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            calibrated_temp <= 10'b0;
            state <= 4'b0;
            cycle_count <= 4'b0;
            temp_sum <= 10'b0;
        end else if (enable) begin
            case (state)
                4'b0000: begin
                    temp_sum <= raw_temp; // Start calibration
                    cycle_count <= 4'b0;
                    state <= 4'b0001;
                end
                4'b0001: begin
                    if (cycle_count < 4'b1000) begin // Wait for 1000 cycles
                        cycle_count <= cycle_count + 1;
                    end else begin
                        calibrated_temp <= temp_sum + offset; // Apply offset
                        state <= 4'b0010; // Move to done state
                    end
                end
                4'b0010: begin
                    // Calibration done, stay in this state
                    state <= 4'b0010;
                end
            endcase
        end
    end
endmodule