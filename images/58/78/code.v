module sync_counter_with_load(
    input clk,
    input sync_reset,
    input enable,
    input load,
    input [7:0] parallel_in,
    output reg [7:0] count_out
);

    always @(posedge clk) begin
        if (sync_reset)
            count_out <= 8'b00000000;
        else if (load)
            count_out <= parallel_in;
        else if (enable)
            count_out <= count_out + 1;
    end

endmodule