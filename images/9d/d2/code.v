module register (
    input clk,
    input reset,
    input enable,
    input [3:0] d,
    output reg [3:0] q
);always @(posedge clk) begin
    if (reset) begin
        q <= 4'b0000;
    end else if (enable) begin
        q <= d;
    end
end

endmodule