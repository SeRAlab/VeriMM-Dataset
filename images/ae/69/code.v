module sync_up_down_counter(
    input clk,
    input sync_reset,
    input enable,
    input direction,
    output reg [3:0] count_out
);

    always @(posedge clk) begin
        if (sync_reset)
            count_out <= 4'b0000;
        else if (enable)
            if (direction)
                count_out <= count_out + 1;
            else
                count_out <= count_out - 1;
    end

endmodule