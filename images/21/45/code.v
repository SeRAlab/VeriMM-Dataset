module interrupt_controller (
    input clk,
    input rst,
    input [3:0] irq,      // 4 interrupt requests
    input ack,           // Acknowledge signal
    output reg irq_out,   // Current interrupt output
    output reg [1:0] irq_served // Indicates which interrupt is being serviced
);

    reg [3:0] irq_pending;
    reg [1:0] current_irq;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            irq_pending <= 4'b0000;
            current_irq <= 2'b00;
            irq_out <= 0;
        end else begin
            // Capture pending IRQs
            irq_pending <= irq_pending | irq;

            // Service the highest priority IRQ
            if (irq_pending != 4'b0000) begin
                irq_out <= 1;
                current_irq <= current_irq + 1; // Move to next interrupt
                irq_pending <= irq_pending & ~(1 << current_irq); // Clear serviced IRQ
                irq_served <= current_irq;
            end else begin
                irq_out <= 0; // No interrupt to service
            end
        end
    end
endmodule