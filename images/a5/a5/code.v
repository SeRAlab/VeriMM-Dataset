module sync_up_down_counter_saturate(
    input clk,
    input sync_reset,
    input enable,
    input direction,
    output reg [7:0] count_out
);

    always @(posedge clk) begin
        if (sync_reset)
            count_out <= 8'b00000000;
        else if (enable) begin
            if (direction) begin
                if (count_out != 8'b11111111)
                    count_out <= count_out + 1;
            end else begin
                if (count_out != 8'b00000000)
                    count_out <= count_out - 1;
            end
        end
    end

endmodule