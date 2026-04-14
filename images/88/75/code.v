module top_module(
    input clk,
    input [6:0] duty_cycle_percentage,
    output reg pulse
);reg [31:0] counter;
    reg [31:0] pulse_width;
    reg [31:0] period;

    always @ (posedge clk) begin
        if (counter == period - 1) begin
            counter <= 0;
            pulse <= 1;
        end else if (counter == pulse_width - 1) begin
            counter <= counter + 1;
            pulse <= 0;
        end else begin
            counter <= counter + 1;
        end
    end

    always @ (duty_cycle_percentage) begin
        period = 10;
        pulse_width = (period * duty_cycle_percentage) / 100;
    end

endmodule