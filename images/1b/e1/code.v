module interrupt_controller (
    input wire clk,
    input wire rst,
    input wire enable,
    input wire [3:0] irq, // 4 interrupt requests
    output reg ack // interrupt acknowledge signal
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            ack <= 0;
        end else if (enable) begin
            if (|irq) begin // Check if any interrupt request is active
                ack <= irq[3] ? 1 : irq[2] ? 1 : irq[1] ? 1 : irq[0] ? 1 : 0; // Acknowledge highest priority IRQ
            end else begin
                ack <= 0; // No interrupt to acknowledge
            end
        end else begin
            ack <= 0; // If not enabled, no acknowledgment
        end
    end
endmodule