module top_module(
    input clk,
    input reset,
    input set,
    input d,
    output reg q,
    output reg q_bar
);always @(posedge clk) begin
        if (reset == 1'b0) begin
            q <= 1'b0;
            q_bar <= 1'b1;
        end else if (set == 1'b0) begin
            q <= 1'b1;
            q_bar <= 1'b0;
        end else begin
            q <= d;
            q_bar <= ~d;
        end
    end

endmodule