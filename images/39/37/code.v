module interrupt_controller (
    input wire [3:0] irq,
    input wire global_enable,
    input wire reset,
    output reg [1:0] irq_out
);

    always @(posedge reset or posedge global_enable) begin
        if (reset) begin
            irq_out <= 2'b00; // Default state
        end else if (global_enable) begin
            case (irq)
                4'b0001: irq_out <= 2'b00; // IRQ0
                4'b0010: irq_out <= 2'b01; // IRQ1
                4'b0100: irq_out <= 2'b10; // IRQ2
                4'b1000: irq_out <= 2'b11; // IRQ3
                default: irq_out <= 2'b00; // No interrupt
            endcase
        end
    end
endmodule