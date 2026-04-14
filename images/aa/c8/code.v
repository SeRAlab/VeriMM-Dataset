module sync_down_counter(
    input clk,
    input sync_reset,
    input enable,
    output reg [11:0] count_out
);

    always @(posedge clk) begin
        if (sync_reset)
            count_out <= 12'b111111111111;
        else if (enable)
            count_out <= count_out - 1;
    end

endmodule