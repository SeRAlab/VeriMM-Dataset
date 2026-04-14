module interrupt_controller (
    input wire clk,
    input wire reset,
    input wire enable,
    input wire [3:0] irq,
    output reg irq_out
);
    reg [1:0] irq_priority;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            irq_out <= 0;
            irq_priority <= 0;
        end else if (enable) begin
            if (irq[0]) begin
                irq_out <= 1;
                irq_priority <= 2'b00; // highest priority
            end else if (irq[1]) begin
                irq_out <= 1;
                irq_priority <= 2'b01;
            end else if (irq[2]) begin
                irq_out <= 1;
                irq_priority <= 2'b10;
            end else if (irq[3]) begin
                irq_out <= 1;
                irq_priority <= 2'b11;
            end else begin
                irq_out <= 0; // no interrupt
            end
        end
    end
endmodule