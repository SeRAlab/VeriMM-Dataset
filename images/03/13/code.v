module interrupt_controller (
    input wire clk,
    input wire rst,
    input wire [3:0] IRQ,
    output reg [3:0] ACK
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            ACK <= 4'b0000;
        end else begin
            ACK <= IRQ & (~IRQ + 1); // Acknowledge the highest priority interrupt
        end
    end
endmodule