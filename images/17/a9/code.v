module pulse_generator(
    input clk,
    input reset,
    input trigger,
    input [3:0] duration, // duration of pulse in clock cycles
    output reg pulse
);
    reg [3:0] counter;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            pulse <= 0;
            counter <= 0;
        end else if (trigger) begin
            pulse <= 1;
            counter <= duration;
        end else if (counter > 0) begin
            counter <= counter - 1;
            if (counter == 1) begin
                pulse <= 0;
            end
        end
    end
endmodule