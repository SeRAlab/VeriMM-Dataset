module interrupt_controller (
    input wire clk,
    input wire rst_n,
    input wire enable,
    input wire [3:0] irq,
    input wire clear,
    output reg int_active
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        int_active <= 0;
    end else if (clear) begin
        int_active <= 0;
    end else if (enable) begin
        if (irq[3]) int_active <= 1;  // IRQ3 has the highest priority
        else if (irq[2]) int_active <= 2; // IRQ2
        else if (irq[1]) int_active <= 3; // IRQ1
        else if (irq[0]) int_active <= 4; // IRQ0
        else int_active <= 0; // No IRQ
    end
end

endmodule