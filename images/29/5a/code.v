module InterruptController (
    input wire clk,
    input wire rst,
    input wire [3:0] active_irq,
    output reg [1:0] highest_irq
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            highest_irq <= 2'b00; // Reset state
        end else begin
            case (active_irq)
                4'b0001: highest_irq <= 2'b00; // IRQ 0
                4'b0010: highest_irq <= 2'b01; // IRQ 1
                4'b0100: highest_irq <= 2'b10; // IRQ 2
                4'b1000: highest_irq <= 2'b11; // IRQ 3
                4'b0011: highest_irq <= 2'b00; // IRQ 0 and 1
                4'b0110: highest_irq <= 2'b01; // IRQ 1 and 2
                4'b1100: highest_irq <= 2'b00; // IRQ 0 and 3
                4'b1111: highest_irq <= 2'b00; // All IRQs, prioritize 0
                default: highest_irq <= 2'b00; // Default to highest priority
            endcase
        end
    end
endmodule