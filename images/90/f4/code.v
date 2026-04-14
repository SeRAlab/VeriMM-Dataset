module sync_up_counter(
    input clk,
    input sync_reset,
    input enable,
    output reg [3:0] count_out
);

    always @(posedge clk) begin
        if (sync_reset)
            count_out <= 4'b0000;
        else if (enable)
            count_out <= count_out + 1;
    end

endmodule