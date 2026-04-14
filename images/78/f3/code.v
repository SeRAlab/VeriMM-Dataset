module async_down_counter(
    input clk,
    input async_reset,
    input enable,
    output reg [19:0] count_out
);

    always @(posedge clk or posedge async_reset) begin
        if (async_reset)
            count_out <= 20'b11111111111111111111;
        else if (enable)
            count_out <= count_out - 1;
    end

endmodule