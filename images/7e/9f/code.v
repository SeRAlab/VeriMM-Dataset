module pulse_gen(
    input clk,
    input trigger,
    output reg pulse
);

    reg trigger_prev = 0;

    always @(posedge clk) begin
        if (trigger && !trigger_prev) begin
            pulse <= 1;
        end else begin
            pulse <= 0;
        end
        trigger_prev <= trigger;
    end

endmodule