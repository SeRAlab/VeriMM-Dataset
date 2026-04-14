module d_flip_flop (
    input clk,
    input reset_n,
    input enable,
    input d,
    output reg q);

always @(posedge clk or negedge reset_n) begin
    if (!reset_n)
        q <= 0;
    else if (enable)
        q <= d;
end

endmodule