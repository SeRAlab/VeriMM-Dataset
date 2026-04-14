module top_module(
    input clk,
    input reset,
    input [31:0] float_in,
    output reg [31:0] fixed_out
);always @(posedge clk) begin
        if (reset) begin
            fixed_out <= 0;
        end else begin
            fixed_out <= $signed(float_in * (1 << 24));
        end
    end

endmodule