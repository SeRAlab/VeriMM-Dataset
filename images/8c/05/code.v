module top_module(
    input clk,
    input reset,
    input ce,
    input d,
    output reg q,
    output reg notifier
);reg q_next;

always @(posedge clk or negedge reset)
begin
    if (!reset) begin
        q <= 1'b0;
        notifier <= 1'b1;
    end
    else if (ce) begin
        q_next <= d;
        notifier <= (q_next != q);
    end
end

always @(posedge clk)
begin
    if (ce) begin
        q <= q_next;
    end
end

endmodule