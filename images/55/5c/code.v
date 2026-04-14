module top_module(
    input clk,
    input [6:0] duty_cycle, // 7-bit input for duty cycle percentage (0-100)
    input [15:0] period, // 16-bit input for period in clock cycles
    output reg pwm_out
);reg [15:0] count; // Counter to track the current position within the period
reg [15:0] high_time; // Counter to track the high time of the PWM signal
reg [6:0] duty_cycle_count; // Counter to track the duty cycle percentage

always @(posedge clk) begin
    // Increment the count
    count <= count + 1;
    
    // If the count has reached the period, reset it and the high time
    if (count == period) begin
        count <= 0;
        high_time <= 0;
    end
    
    // If the high time has reached the duty cycle percentage, set the output high
    if (high_time == ((duty_cycle * period) / 100)) begin
        pwm_out <= 1;
    end
    
    // If the duty cycle count has reached 100, reset it and the high time
    if (duty_cycle_count == 100) begin
        duty_cycle_count <= 0;
        high_time <= 0;
    end
    
    // If the output is currently high and the high time has reached the end of the period, set the output low
    if (pwm_out && (count == period)) begin
        pwm_out <= 0;
    end
    
    // If the output is currently high and the high time has reached the duty cycle percentage, increment the duty cycle count
    if (pwm_out && (high_time == ((duty_cycle * period) / 100))) begin
        duty_cycle_count <= duty_cycle_count + 1;
    end
    
    // If the output is currently low and the high time has not yet reached the duty cycle percentage, increment the high time
    if (!pwm_out && (high_time < ((duty_cycle * period) / 100))) begin
        high_time <= high_time + 1;
    end
end

endmodule