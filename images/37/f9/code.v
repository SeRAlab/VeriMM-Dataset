module interrupt_controller (
    input wire clk,
    input wire rst,
    input wire [2:0] irq, // 3 interrupt requests
    output reg ack // interrupt acknowledge
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        ack <= 0;
    end else begin
        case (irq)
            3'b100: ack <= 1; // IRQ0
            3'b010: ack <= 1; // IRQ1
            3'b001: ack <= 1; // IRQ2
            default: ack <= 0; // No IRQ
        endcase
    end
end

endmodule