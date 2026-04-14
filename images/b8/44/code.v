module top_module(
    input clk,
    input d,
    input set,
    input reset,
    input preset,
    output reg q,
    output reg q_bar
    );always @(posedge clk) begin
        if (reset) begin
            q <= 1'b0;
            q_bar <= 1'b1;
        end else if (set) begin
            q <= 1'b1;
            q_bar <= 1'b0;
        end else if (preset) begin
            q <= 1'b1;
            q_bar <= 1'b0;
        end else begin
            q <= d;
            q_bar <= ~d;
        end
    end

endmodule