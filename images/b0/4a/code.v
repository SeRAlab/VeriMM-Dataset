module sync_down_counter_zero(
    input clk,
    input sync_reset,
    input enable,
    output reg [7:0] count_out
);

    always @(posedge clk) begin
        if (sync_reset)
            count_out <= 8'b00000000;
        else if (enable)
            count_out <= count_out - 1;
    end

endmodule