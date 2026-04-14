module top_module(
    input clk,
    input rst,
    input en,
    input [3:0] in,
    output reg [3:0] out
);always @(posedge clk) begin
        if (rst) begin
            out <= 4'b0;
        end else if (en) begin
            out <= {out[2:0], in[0]};
        end
    end

endmodule