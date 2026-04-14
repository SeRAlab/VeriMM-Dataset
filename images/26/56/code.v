module interrupt_controller (
    input wire clk,
    input wire reset,
    input wire [3:0] irq, // 4 interrupt request lines
    output reg [3:0] active_irq, // Active interrupt output
    output reg irq_ack // Interrupt acknowledge signal
);

    reg [3:0] irq_reg;
    reg [1:0] current_priority;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            irq_reg <= 4'b0000;
            active_irq <= 4'b0000;
            irq_ack <= 0;
            current_priority <= 2'b00;
        end else begin
            irq_reg <= irq; // Store incoming IRQs

            if (irq_reg != 4'b0000) begin
                case (current_priority)
                    2'b00: if (irq_reg[0]) begin active_irq <= 4'b0001; irq_ack <= 1; end
                    2'b01: if (irq_reg[1]) begin active_irq <= 4'b0010; irq_ack <= 1; end
                    2'b10: if (irq_reg[2]) begin active_irq <= 4'b0100; irq_ack <= 1; end
                    2'b11: if (irq_reg[3]) begin active_irq <= 4'b1000; irq_ack <= 1; end
                endcase
                current_priority <= current_priority + 1;
            end else begin
                irq_ack <= 0; // No interrupt acknowledged if none are active
            end
        end
    end
endmodule