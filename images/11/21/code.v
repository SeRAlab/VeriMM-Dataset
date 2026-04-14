module interrupt_controller (
    input wire [3:0] irq,   // Interrupt Requests
    input wire clk,         // Clock
    input wire reset,       // Reset signal
    output reg int_signal   // Interrupt Signal to Processor
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        int_signal <= 0;
    end else begin
        int_signal <= |irq; // Generate interrupt if any IRQ is high
    end
end

endmodule