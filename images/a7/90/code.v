module d_flip_flop (
    input clk,
    input set,
    input reset,
    input d,
    output reg q );always @(posedge clk) begin
    if (set)
        q <= 1'b1;
    else if (reset)
        q <= 1'b0;
    else
        q <= d;
end

endmodule