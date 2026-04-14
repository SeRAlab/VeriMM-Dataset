module top_module(
    input [3:0] in,
    input clk,
    input rst,
    output reg [3:0] out
);always @(posedge clk) begin
        if (rst) begin
            out <= 4'b0000;
        end else begin
            out <= {in[1:0], 2'b00};
        end
    end

endmodule