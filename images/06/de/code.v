module pulse_generator (
    input clk,
    input reset,
    input trigger,
    output reg pulse
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            pulse <= 0;
        end else if (trigger) begin
            pulse <= 1;
        end else begin
            pulse <= 0;
        end
    end
endmodule