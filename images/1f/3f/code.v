module interrupt_controller(
    input wire [2:0] irq,
    output reg ack
);
    always @(irq) begin
        if (irq != 3'b000) begin
            ack = 1'b1; // Set ack high if any irq is high
        end else begin
            ack = 1'b0; // Reset ack if all irq are low
        end
    end
endmodule