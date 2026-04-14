module top_module(
    input clk,
    input [15:0] D,
    input L,
    output reg [15:0] out
);always @(posedge clk) begin
        if (L) begin
            out <= D;
        end
        else begin
            out <= {out[14:0], 1'b0};
        end
    end

endmodule