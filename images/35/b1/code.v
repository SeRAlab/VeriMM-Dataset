module switching_regulator (
    input wire enable,
    input wire [7:0] Vref,
    input wire [7:0] Vfb,
    output reg PWM_out
);

reg [7:0] error;
reg [7:0] duty_cycle;

always @(*) begin
    if (!enable) begin
        PWM_out = 0;
    end else begin
        error = Vref - Vfb;
        if (error > 8'd0) begin
            duty_cycle = (error > 8'd255) ? 8'd255 : error;
            PWM_out = (duty_cycle > 8'd128) ? 1 : 0; // Simple toggle mechanism
        end else begin
            PWM_out = 0; // No output if feedback voltage is higher than reference
        end
    end
end

endmodule