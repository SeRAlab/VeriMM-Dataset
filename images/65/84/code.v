module top_module(
    input clock,
    input [7:0] duty_cycle,
    output reg pwm
);reg [7:0] counter;

always @(posedge clock) begin
    if (counter == 0) begin
        pwm <= 1;
    end else if (counter == duty_cycle) begin
        pwm <= 0;
        counter <= 0;
    end else begin
        counter <= counter + 1;
    end
end

endmodule