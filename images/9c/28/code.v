module d_ff_async(
    input clk,
    input async_reset,
    input enable,
    input d,
    output reg q
);

    always @(posedge clk or posedge async_reset) begin
        if (async_reset)
            q <= 1'b0;
        else if (enable)
            q <= d;
    end

endmodule