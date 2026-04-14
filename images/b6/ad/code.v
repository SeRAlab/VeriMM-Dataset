module sync_up_counter_6bit(
    input clk,
    input sync_reset,
    input enable,
    output reg [5:0] count_out
);

    always @(posedge clk) begin
        if (sync_reset)
            count_out <= 6'b000000;
        else if (enable)
            count_out <= count_out + 1;
    end

endmodule