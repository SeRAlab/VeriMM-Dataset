module top_module(
    input clk,
    input reset,
    input [31:0] timer_count,
    input timer_enable,
    input timer_interrupt_clear,
    output reg timer_count_done,
    output reg timer_interrupt
);reg [31:0] timer_count_running;

always @(posedge clk) begin
    if (reset) begin
        timer_count_running <= 32'b0;
        timer_count_done <= 1'b0;
        timer_interrupt <= 1'b0;
    end else if (timer_enable) begin
        timer_count_running <= timer_count_running + 1;
        if (timer_count_running >= timer_count) begin
            timer_count_running <= 32'b0;
            timer_count_done <= 1'b1;
            timer_interrupt <= 1'b1;
        end else begin
            timer_count_done <= 1'b0;
            timer_interrupt <= 1'b0;
        end
    end else begin
        timer_count_running <= 32'b0;
        timer_count_done <= 1'b0;
        timer_interrupt <= 1'b0;
    end
end

always @(posedge clk) begin
    if (reset) begin
        timer_interrupt <= 1'b0;
    end else if (timer_interrupt_clear) begin
        timer_interrupt <= 1'b0;
    end
end

endmodule