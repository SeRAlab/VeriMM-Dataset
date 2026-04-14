module top_module(
    input a,
    input b,
    input clk,       // Added clk input
    output reg sum,
    output reg cout
);reg s1, c1;

always @ (a or b) begin
    s1 = a ^ b;
    c1 = a & b;
end

always @ (posedge clk) begin
    sum <= s1;
    cout <= c1;
end

endmodule