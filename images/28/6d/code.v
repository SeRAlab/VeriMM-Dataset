module pwm_generator (
    input clk,
    input rst,
    input [3:0] duty_cycle, // 4-bit input for duty cycle
    output reg pwm_out
);
    reg [7:0] counter; // 8-bit counter to generate PWM
    parameter PERIOD = 100; // count period for 1 kHz

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 0;
            pwm_out <= 0;
        end else begin
            if (counter < PERIOD) begin
                counter <= counter + 1;
            end else begin
                counter <= 0;
            end
            
            // Set PWM output based on duty cycle
            if (counter < (duty_cycle * PERIOD) / 16) begin
                pwm_out <= 1;
            end else begin
                pwm_out <= 0;
            end
        end
    end
endmodule