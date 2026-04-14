module PWM (
    input wire clk,
    input wire rst,
    input wire [1:0] duty,
    output reg pwm_out
);

reg [7:0] counter; // 8-bit counter for 256 clock cycles

always @(posedge clk or posedge rst) begin
    if (rst) begin
        counter <= 8'b0;
        pwm_out <= 1'b0;
    end else begin
        if (counter < 255) begin
            counter <= counter + 1;
        end else begin
            counter <= 8'b0; // Reset counter
        end

        // Setting PWM output based on duty cycle
        case (duty)
            2'b00: pwm_out <= (counter < 0) ? 1'b0 : 1'b0;      // 0%
            2'b01: pwm_out <= (counter < 64) ? 1'b1 : 1'b0;     // 25%
            2'b10: pwm_out <= (counter < 128) ? 1'b1 : 1'b0;    // 50%
            2'b11: pwm_out <= (counter < 192) ? 1'b1 : 1'b0;    // 75%
            default: pwm_out <= 1'b0;
        endcase
    end
end

endmodule