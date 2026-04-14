module top_module(
    input                 clk,
    input       [7:0]     a, b, c, d,
    output reg  [7:0]     f
);reg [7:0] y1, y2, y3, d1, d2;


always @ (posedge clk) begin
    y1 <= a + b;
    y2 <= c - d;
    d1 <= d;
end


always @ (posedge clk) begin
    y3 <= y1 + y2;
    d2 <=  d1;
end


always @ (posedge clk) begin
    f <= y3 * d2;
end

endmodule