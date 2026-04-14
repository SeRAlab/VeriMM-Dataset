module interrupt_controller (
    input wire clk,
    input wire reset,
    input wire [3:0] irq,
    output reg [1:0] serviced_irq
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            serviced_irq <= 2'b00; // Clear serviced interrupt on reset
        end else begin
            if (irq[0]) begin
                serviced_irq <= 2'b00; // Service IRQ 0
            end else if (irq[1]) begin
                serviced_irq <= 2'b01; // Service IRQ 1
            end else if (irq[2]) begin
                serviced_irq <= 2'b10; // Service IRQ 2
            end else if (irq[3]) begin
                serviced_irq <= 2'b11; // Service IRQ 3
            end
        end
    end
endmodule