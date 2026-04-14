module top_module(
    input clk,
    input reset,
    input d,
    output reg q
);reg q1;

always @(posedge clk)
begin
    if (reset)
        q1 <= 1'b0;
    else
        q1 <= d;
end

always @(posedge clk)
begin
    q <= q1;
end

endmodule