module top_module(
    input clk,
    input [3:0] duty_cycle,
    output reg pwm_out
);reg [3:0] counter;

always @(posedge clk) begin
    counter <= counter + 1;
    if (counter >= 15) begin
        counter <= 0;
        pwm_out <= (counter < duty_cycle);
    end
end

endmodule