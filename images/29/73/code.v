module interrupt_controller (
    input wire [3:0] irq,
    input wire ack,
    output reg [3:0] int_out,
    output reg int_active
);
    reg [3:0] active_interrupts;

    always @(posedge ack) begin
        if (active_interrupts) begin
            int_out <= active_interrupts;
            active_interrupts <= active_interrupts & ~int_out; // Clear acknowledged interrupt
        end
    end

    always @(*) begin
        active_interrupts = irq; // Update active interrupts
        int_active = |active_interrupts; // Set active flag if any interrupt is active
    end
endmodule