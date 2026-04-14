module interrupt_controller(
    input clk,
    input reset,
    input [3:0] irq,      // Interrupt requests: irq[0] highest priority
    input enable,
    output reg [1:0] irq_out // Indicates which interrupt is being serviced
);
  
    reg [3:0] irq_reg;
  
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            irq_out <= 2'b00;
            irq_reg <= 4'b0000;
        end else if (enable) begin
            irq_reg <= irq; // Store the current interrupts
            case (irq_reg)
                4'b0001: irq_out <= 2'b00; // irq0
                4'b0010: irq_out <= 2'b01; // irq1
                4'b0100: irq_out <= 2'b10; // irq2
                4'b1000: irq_out <= 2'b11; // irq3
                default: irq_out <= 2'b00;  // Default to the highest priority
            endcase
        end
    end
endmodule