module interrupt_controller(
    input wire clk,
    input wire rst,
    input wire IRQ,
    output reg IRQ_ACK
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            IRQ_ACK <= 0;
        end else begin
            if (IRQ) begin
                IRQ_ACK <= 1;
            end else begin
                IRQ_ACK <= 0;
            end
        end
    end

endmodule