module async_down_counter(
    input clk,
    input async_reset,
    input enable,
    output reg [7:0] count_out
);

    always @(posedge clk or posedge async_reset) begin
        if (async_reset)
            count_out <= 8'b0;
        else if (enable)
            count_out <= count_out - 1;
    end

endmodule