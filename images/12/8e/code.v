module interrupt_controller(
    input wire clk,
    input wire rst,
    input wire irq0,
    input wire irq1,
    input wire irq2,
    input wire irq3,
    input wire ack,
    output reg irq_out
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            irq_out <= 0;
        end else if (ack) begin
            if (irq3) irq_out <= 0;
            else if (irq2) irq_out <= 0;
            else if (irq1) irq_out <= 0;
            else if (irq0) irq_out <= 0;
        end else begin
            if (irq3) irq_out <= 1;
            else if (irq2) irq_out <= 1;
            else if (irq1) irq_out <= 1;
            else if (irq0) irq_out <= 1;
            else irq_out <= 0;
        end
    end
endmodule