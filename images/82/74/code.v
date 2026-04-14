module top_module(
    input clk,
    input data,
    input set,
    input reset,
    output reg q,
    output reg q_n
);always @(posedge clk) begin
        if (set && !reset) begin
            q <= 1;
        end else if (!set && reset) begin
            q <= 0;
        end else if (set && reset) begin
            q <= 0;
        end else begin
            q <= data;
        end
    end

    assign q_n = ~q;

endmodule