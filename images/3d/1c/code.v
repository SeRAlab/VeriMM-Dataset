module interrupt_controller (
    input wire clk,
    input wire rst,
    input wire [3:0] irq,
    input wire ack,
    output reg [1:0] irq_ack
);

    reg [3:0] irq_latched;
    reg [1:0] highest_priority;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            irq_latched <= 4'b0000;
            irq_ack <= 2'b00;
        end else begin
            // Latch the interrupt requests
            irq_latched <= irq_latched | irq;

            // Determine the highest priority interrupt
            if (irq_latched[0]) highest_priority <= 2'b00; // IRQ0
            else if (irq_latched[1]) highest_priority <= 2'b01; // IRQ1
            else if (irq_latched[2]) highest_priority <= 2'b10; // IRQ2
            else if (irq_latched[3]) highest_priority <= 2'b11; // IRQ3
            else highest_priority <= 2'b00; // No interrupt

            // Acknowledge the interrupt
            if (ack) begin
                irq_ack <= highest_priority;
                irq_latched <= irq_latched & ~(1 << highest_priority); // Clear acknowledged interrupt
            end else begin
                irq_ack <= 2'b00; // No acknowledgment
            end
        end
    end

endmodule