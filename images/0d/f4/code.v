module interrupt_controller (
    input wire clk,
    input wire reset,
    input wire [3:0] irq,
    output reg ack
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            ack <= 0;
        end else begin
            case (irq)
                4'b0001: ack <= 1; // Acknowledge IRQ0
                4'b0010: ack <= 1; // Acknowledge IRQ1
                4'b0100: ack <= 1; // Acknowledge IRQ2
                4'b1000: ack <= 1; // Acknowledge IRQ3
                default: ack <= 0;  // No interrupt
            endcase
        end
    end
endmodule