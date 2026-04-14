module interrupt_controller(
    input wire clk,
    input wire irq1,
    input wire irq2,
    input wire mask,
    output reg [1:0] output_irq // 00: none, 01: irq1, 10: irq2
);
    always @(posedge clk) begin
        if (irq2) begin
            output_irq <= 2'b10; // Service irq2
        end else if (irq1 && !mask) begin
            output_irq <= 2'b01; // Service irq1
        end else begin
            output_irq <= 2'b00; // No interrupt serviced
        end
    end
endmodule