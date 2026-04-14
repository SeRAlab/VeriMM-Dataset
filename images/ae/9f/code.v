module top_module(
    input clk,
    input reset_n,
    input d,
    input en_n,
    output reg q,
    output reg q_n
);always @(posedge clk or negedge reset_n)
    if (!reset_n)
        begin
            q <= 1'b0;
            q_n <= 1'b1;
        end
    else if (!en_n)
        begin
            q <= q;
            q_n <= q_n;
        end
    else
        begin
            q <= d;
            q_n <= ~d;
        end

endmodule