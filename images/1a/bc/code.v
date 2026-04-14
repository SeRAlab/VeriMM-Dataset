module interrupt_controller (
    input wire clk,
    input wire reset,
    input wire irq0,
    input wire irq1,
    output reg [1:0] ack
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        ack <= 2'b00;
    end else begin
        if (irq0) begin
            ack <= 2'b01; // Acknowledge IRQ0
        end else if (irq1) begin
            ack <= 2'b10; // Acknowledge IRQ1
        end else begin
            ack <= 2'b00; // No interrupts
        end
    end
end

endmodule