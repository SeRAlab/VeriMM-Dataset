module top_module(
    clk,
    reset,
    ce,
    a,
    b,
    p
);parameter WIDTH = 32;

input clk;
input reset;
input ce;
input signed [WIDTH-1:0] a;
input signed [WIDTH-1:0] b;
output signed [WIDTH-1:0] p;

reg signed [WIDTH-1:0] a_reg;
reg signed [WIDTH-1:0] b_reg;
reg signed [WIDTH-1:0] p_reg;

always @(posedge clk) begin
    if (reset) begin
        a_reg <= 0;
        b_reg <= 0;
        p_reg <= 0;
    end else if (ce) begin
        a_reg <= a;
        b_reg <= b;
        p_reg <= a_reg * b_reg;
    end
end

assign p = p_reg;

endmodule