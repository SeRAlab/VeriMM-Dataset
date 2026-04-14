module interrupt_controller (
    input wire [3:0] irq,  // 4-bit input for IRQs
    output reg [1:0] highest_irq // 2-bit output for highest priority IRQ
);
    always @(*) begin
        casez (irq)
            4'b1??? : highest_irq = 2'b00; // IRQ0
            4'b01?? : highest_irq = 2'b01; // IRQ1
            4'b001? : highest_irq = 2'b10; // IRQ2
            4'b0001 : highest_irq = 2'b11; // IRQ3
            default : highest_irq = 2'b00; // No IRQ active
        endcase
    end
endmodule