module down_counter_with_enable_sync_reset_4bit(
    input clk,
    input reset,
    input enable,
    output reg [3:0] count
    );

    always @(posedge clk) begin
        if (reset) begin
            count <= 4'b1111;
        end else if (enable) begin
            count <= count - 1;
        end
    end
endmodule