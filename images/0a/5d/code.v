module fan_speed_controller(
    input clk,
    input reset,
    input [1:0] speed,
    output reg [2:0] pwm_signal,
    output reg fan_status
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            pwm_signal <= 3'b000;
            fan_status <= 1'b0;
        end else begin
            case (speed)
                2'b00: begin // Off
                    pwm_signal <= 3'b000;
                    fan_status <= 1'b0;
                end
                2'b01: begin // Low
                    pwm_signal <= 3'b011; // 33% duty cycle
                    fan_status <= 1'b1;
                end
                2'b10: begin // Medium
                    pwm_signal <= 3'b101; // 50% duty cycle
                    fan_status <= 1'b1;
                end
                2'b11: begin // High
                    pwm_signal <= 3'b111; // 100% duty cycle
                    fan_status <= 1'b1;
                end
                default: begin
                    pwm_signal <= 3'b000;
                    fan_status <= 1'b0;
                end
            endcase
        end
    end
endmodule