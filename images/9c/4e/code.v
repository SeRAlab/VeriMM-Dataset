module top_module(
    input clk,
    input d,
    output reg q
);reg t1, t2;

always @(posedge clk) begin
    t1 <= d;
end

always @(posedge clk) begin
    t2 <= t1;
end

always @(posedge clk) begin
    q <= t2;
end

endmodule