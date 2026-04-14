module InterruptController (
    input wire clk,
    input wire rst,
    input wire [3:0] irq,           // 4 IRQ lines
    input wire ack,                 // Acknowledge signal
    output reg [1:0] service        // Service line output (2-bit to indicate which IRQ is being serviced)
);

reg [3:0] prioritized_irq;

// Priority encoder logic
always @(posedge clk or posedge rst) begin
    if (rst) begin
        prioritized_irq <= 4'b0000;
        service <= 2'b00;
    end else begin
        prioritized_irq <= irq; // Capture IRQ lines
        if (ack) begin
            service <= 2'b00; // Reset service line on ack
        end else begin
            // Check for the highest priority IRQ
            if (prioritized_irq[3]) service <= 2'b11; // Highest priority
            else if (prioritized_irq[2]) service <= 2'b10;
            else if (prioritized_irq[1]) service <= 2'b01;
            else if (prioritized_irq[0]) service <= 2'b00;
        end
    end
end

endmodule