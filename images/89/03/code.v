module sync_down_counter_9bit(
    input clk,
    input sync_reset,
    input enable,
    output reg [8:0] count_out
);

    always @(posedge clk) begin
        if (sync_reset)
            count_out <= 9'b000000000;
        else if (enable)
            count_out <= count_out - 1;
    end

endmodule