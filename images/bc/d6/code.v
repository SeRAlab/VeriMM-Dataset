module down_counter_with_enable_sync_reset(
    input clk,
    input reset,
    input enable,
    output reg [6:0] count
    );

    always @(posedge clk) begin
        if (reset) begin
            count <= 7'b1111111;
        end else if (enable) begin
            count <= count - 1;
        end
    end
endmodule