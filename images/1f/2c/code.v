module interrupt_controller (
    input wire clk,
    input wire rst,
    input wire irq0,
    input wire irq1,
    output reg [1:0] active_irq
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        active_irq <= 2'b00; // Clear output on reset
    end else begin
        if (irq0) begin
            active_irq <= 2'b01; // IRQ0 active
        end else if (irq1) begin
            active_irq <= 2'b10; // IRQ1 active
        end else begin
            active_irq <= 2'b00; // No active interrupts
        end
    end
end

endmodule