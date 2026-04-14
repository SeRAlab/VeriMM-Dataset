module top_module(
    input clk,
    input ctrl,
    output reg pwm_out
);reg [31:0] counter;
parameter DUTY_CYCLE = 75;

always @(posedge clk) begin
    if(ctrl) begin
        counter <= counter + 1;
        if(counter >= 100) begin
            counter <= 0;
            pwm_out <= 1;
        end
        else if(counter >= DUTY_CYCLE) begin
            pwm_out <= 0;
        end
    end
    else begin
        counter <= 0;
        pwm_out <= 0;
    end
end

endmodule