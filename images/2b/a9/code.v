module interrupt_controller (
    input wire clk,
    input wire enable,
    input wire [3:0] irq,
    output reg [1:0] ack
);
    always @(posedge clk) begin
        if (enable) begin
            if (irq[3]) ack <= 2'b11; // IRQ3
            else if (irq[2]) ack <= 2'b10; // IRQ2
            else if (irq[1]) ack <= 2'b01; // IRQ1
            else if (irq[0]) ack <= 2'b00; // IRQ0
            else ack <= 2'b00; // No IRQ
        end
    end
endmodule