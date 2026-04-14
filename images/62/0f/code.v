module async_down_counter(
    input clk,
    input async_reset,
    input enable,
    output reg [15:0] count_out
);

    always @(posedge clk or posedge async_reset) begin
        if (async_reset)
            count_out <= 16'b0000000000000000;
        else if (enable)
            count_out <= count_out - 1;
    end

endmodule