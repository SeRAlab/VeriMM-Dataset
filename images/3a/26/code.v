module interrupt_controller (
    input wire clk,
    input wire rst,
    input wire irq,
    output reg ack
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            ack <= 0;
        end else if (irq) begin
            ack <= 1;
        end else begin
            ack <= 0;
        end
    end
endmodule