module top_module(
    input clk,
    input rst,
    input load,
    input [3:0] in,
    input shift,
    output reg [3:0] out
);always @(posedge clk) begin
        if (rst) begin
            out <= 4'b0;
        end else if (load) begin
            out <= in;
        end else if (shift) begin
            out <= {out[2:0], 1'b0};
        end
    end

endmodule