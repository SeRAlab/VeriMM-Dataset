module shift_register_with_enable_sync_reset_8bit(
    input clk,
    input reset,
    input enable,
    output reg [7:0] data
    );

    always @(posedge clk) begin
        if (reset) begin
            data <= 8'b00000000;
        end else if (enable) begin
            data <= data << 1;
        end
    end
endmodule