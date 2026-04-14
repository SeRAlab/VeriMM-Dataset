module top_module(
    input clk_in,
    output reg clk_out,
    input [3:0] delay_value,
    input reset
);reg [3:0] counter = 4'd0;
    reg reset_sync;

    always @(posedge clk_in or negedge reset) begin
        if (!reset) begin
            clk_out <= 1'b0;
            counter <= 4'd0;
            reset_sync <= 1'b1;
        end else if (counter == delay_value) begin
            clk_out <= 1'b1;
            counter <= 4'd0;
            reset_sync <= 1'b0;
        end else begin
            clk_out <= 1'b0;
            counter <= counter + 1;
            reset_sync <= 1'b0;
        end
    end

    always @(posedge clk_in) begin
        if (reset_sync) begin
            counter <= 4'd0;
        end
    end

endmodule