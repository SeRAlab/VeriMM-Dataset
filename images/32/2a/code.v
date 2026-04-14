module interrupt_controller (
    input wire clk,
    input wire IRQ0,
    input wire IRQ1,
    output reg ACK
);

    always @(posedge clk) begin
        if (IRQ0) begin
            ACK <= 1; // Acknowledge IRQ0
        end else if (IRQ1) begin
            ACK <= 1; // Acknowledge IRQ1
        end else begin
            ACK <= 0; // No interrupt
        end
    end
endmodule