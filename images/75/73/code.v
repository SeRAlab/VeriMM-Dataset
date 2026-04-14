module top_module(
    input clk,
    input [7:0] max_val,
    input reset,
    output reg [7:0] out
);always @ (posedge clk or posedge reset) begin
        if (reset) begin
            out <= 0;
        end else if (out == max_val) begin
            out <= 0;
        end else begin
            out <= out + 1;
        end
    end

endmodule