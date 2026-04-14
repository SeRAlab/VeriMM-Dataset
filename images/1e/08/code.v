module interrupt_controller (
    input wire clk,
    input wire rst,
    input wire [3:0] irq, // Interrupt requests
    output reg ack // Acknowledge signal
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        ack <= 0; // Reset ack signal
    end else begin
        casez (irq) // Check for active interrupts
            4'b1??? : ack <= 1; // IRQ0
            4'b01?? : ack <= 1; // IRQ1
            4'b001? : ack <= 1; // IRQ2
            4'b0001 : ack <= 1; // IRQ3
            default : ack <= 0; // No active interrupts
        endcase
    end
end

endmodule