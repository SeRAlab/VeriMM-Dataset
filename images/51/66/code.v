module top_module(
    input clock,
    input reset,
    input [7:0] dutyCycle,
    output reg pwm,
    output reg done
);reg [23:0] counter = 0;
    reg [7:0] threshold = 0;
    reg [7:0] duty = 0;

    always @(posedge clock) begin
        if (reset) begin
            counter <= 0;
            threshold <= 0;
            duty <= 0;
            pwm <= 0;
            done <= 0;
        end else begin
            // calculate threshold based on duty cycle
            duty <= dutyCycle;
            threshold <= (256 * (duty / 100)) - 1;
            
            // increment counter and reset at end of cycle
            if (counter == 999) begin
                counter <= 0;
                done <= 1;
            end else begin
                counter <= counter + 1;
                done <= 0;
            end
            
            // set pwm value based on counter and threshold
            if (counter < threshold) begin
                pwm <= 1;
            end else begin
                pwm <= 0;
            end
        end
    end

endmodule