module interrupt_controller (
    input wire clk,
    input wire rst,
    input wire GIE,           // Global Interrupt Enable
    input wire IRQ0,         // Interrupt Request 0
    input wire IRQ1,         // Interrupt Request 1
    input wire IRQ2,         // Interrupt Request 2
    input wire ACK,          // Acknowledge signal
    output reg INT           // Interrupt signal
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            INT <= 0;
        end else if (GIE && (IRQ0 || IRQ1 || IRQ2)) begin
            INT <= 1; // Set INT if any IRQ is active and GIE is high
        end else if (ACK) begin
            INT <= 0; // Clear INT on ACK
        end
    end
endmodule