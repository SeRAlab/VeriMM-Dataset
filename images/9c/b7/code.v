module top_module(
    input clk,
    input [3:0] d,
    input set_b,
    output reg [3:0] q
);always @(posedge clk) begin
    if (set_b) begin
        q <= d;
    end else begin
        q <= q;
    end
end

endmodule