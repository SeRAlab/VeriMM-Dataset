module async_down_counter_max(
    input clk,
    input async_reset,
    input enable,
    output reg [4:0] count_out
);

    always @(posedge clk or posedge async_reset) begin
        if (async_reset)
            count_out <= 5'b11111;
        else if (enable)
            count_out <= count_out - 1;
    end

endmodule