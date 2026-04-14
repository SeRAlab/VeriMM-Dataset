module interrupt_controller (
    input wire clk,
    input wire hw_interrupt,
    input wire sw_interrupt,
    output reg interrupt_active,
    output reg interrupt_type
);

reg servicing;

always @(posedge clk) begin
    if (!servicing) begin
        if (hw_interrupt) begin
            interrupt_active <= 1;
            interrupt_type <= 0; // Hardware interrupt
            servicing <= 1;
        end else if (sw_interrupt) begin
            interrupt_active <= 1;
            interrupt_type <= 1; // Software interrupt
            servicing <= 1;
        end
    end else begin
        // Keep servicing until the current interrupt is handled.
        // In this example, we assume handling takes one clock cycle.
        interrupt_active <= 0;
        servicing <= 0;
    end
end

endmodule