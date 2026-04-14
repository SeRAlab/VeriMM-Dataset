module top_module(
    input clk,
    input d,
    output reg q
);reg d1, d2, d3;

always @(posedge clk) begin
    d1 <= d;
end

always @(posedge clk) begin
    d2 <= d1;
end

always @(posedge clk) begin
    d3 <= d2;
end

always @(posedge clk) begin
    q <= d3;
end

endmodule