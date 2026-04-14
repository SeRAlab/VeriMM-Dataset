module top_module(
    input clk,
    input ld,
    input [31:0] d,
    output reg [31:0] q
);always @(posedge clk) begin
        if (ld) begin
            q <= d;
        end
    end

endmodule