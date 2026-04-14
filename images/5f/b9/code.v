module sync_up_counter_with_load(
    input clk,
    input sync_reset,
    input enable,
    input load,
    input [3:0] data_in,
    output reg [3:0] count_out
);

    always @(posedge clk) begin
        if (sync_reset)
            count_out <= 4'b0000;
        else if (load)
            count_out <= data_in;
        else if (enable)
            count_out <= count_out + 1;
    end

endmodule