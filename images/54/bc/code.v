module top_module(
    input clk, rst, load,
    input [3:0] in,
    output reg [3:0] out
);always @(posedge clk) begin
        if (rst) begin
            out <= 4'b0;
        end else if (load) begin
            out <= in;
        end else begin
            out <= {out[2:0], 1'b0};
        end
    end

endmodule