module top_module(
    input clk,
    input d,
    output reg q,
    output reg q_delayed
);reg q_pipeline;

always @(posedge clk) begin
    q_pipeline <= d;
    q <= q_pipeline;
end

always @(posedge clk) begin
    q_delayed <= q_pipeline;
end

endmodule