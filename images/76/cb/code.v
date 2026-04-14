module d_flip_flop(
    input clk,
    input rst,
    input enable,
    input d,

    output reg q
);

// D Flip-Flop logic
always @(posedge clk) begin
    if (rst)
        q <= 1'b0;
    else if (enable)
        q <= d;
end

endmodule