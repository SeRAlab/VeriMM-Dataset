module interrupt_controller(
    input wire clk,
    input wire irq0,
    input wire irq1,
    input wire irq2,
    input wire irq3,
    output reg ack0,
    output reg ack1,
    output reg ack2,
    output reg ack3
);
    always @(posedge clk) begin
        if (irq0) begin
            ack0 <= 1;
            ack1 <= 0;
            ack2 <= 0;
            ack3 <= 0;
        end else if (irq1) begin
            ack0 <= 0;
            ack1 <= 1;
            ack2 <= 0;
            ack3 <= 0;
        end else if (irq2) begin
            ack0 <= 0;
            ack1 <= 0;
            ack2 <= 1;
            ack3 <= 0;
        end else if (irq3) begin
            ack0 <= 0;
            ack1 <= 0;
            ack2 <= 0;
            ack3 <= 1;
        end else begin
            ack0 <= 0;
            ack1 <= 0;
            ack2 <= 0;
            ack3 <= 0;
        end
    end
endmodule