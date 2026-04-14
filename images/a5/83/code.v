module top_module(
    input clk,
    input reset,
    input preset,
    input d,
    output reg q,
    output reg q_n
);always @(posedge clk) begin
    if (reset) begin
        q <= 1'b0;
        q_n <= 1'b1;
    end else if (preset) begin
        q <= 1'b1;
        q_n <= 1'b0;
    end else begin
        q <= d;
        q_n <= ~d;
    end
end

endmodule