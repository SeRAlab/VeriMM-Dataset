module thermal_sensor_calibration(
    input clk,
    input reset,
    input start,
    input [11:0] raw_temp,
    input [11:0] calibration_factor,
    output reg [11:0] calibrated_temp,
    output reg done
);

    reg [1:0] state;
    parameter IDLE = 2'b00, CALIBRATING = 2'b01, DONE = 2'b10;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            calibrated_temp <= 12'b0;
            done <= 1'b0;
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        state <= CALIBRATING;
                        done <= 1'b0;
                    end
                end
                CALIBRATING: begin
                    calibrated_temp <= raw_temp + calibration_factor; // Simple calibration logic
                    state <= DONE;
                end
                DONE: begin
                    done <= 1'b1;
                    state <= IDLE;
                end
            endcase
        end
    end
endmodule