module dff_async_reset(
    input clk,
    input rst,
    input d,

    output reg q
);

// D flip-flop logic with asynchronous reset
always @(posedge clk or posedge rst) begin
    if (rst)
        q <= 0;
    else
        q <= d;
end

endmodule