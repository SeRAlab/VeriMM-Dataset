module sync_up_counter_saturate(
    input clk,
    input sync_reset,
    input enable,
    output reg [15:0] count_out
);

    always @(posedge clk) begin
        if (sync_reset)
            count_out <= 16'b0000000000000000;
        else if (enable)
            if (count_out != 16'b1111111111111111)
                count_out <= count_out + 1;
    end

endmodule