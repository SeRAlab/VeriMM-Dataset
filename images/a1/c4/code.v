module top_module(
    input [3:0] a,
    input [3:0] b,
    input clk,      // Added clk input
    output reg [4:0] c,
    output reg co
);reg [3:0] sum1, sum2;
reg [4:0] c1, c2;

always @(*) begin
    sum1 = a + b;
    c1 = {1'b0, sum1};
end

always @(posedge clk) begin
    sum2 = c1[3:0] + c2[3:0];
    c2 = {co, sum2};
    c = c2;
end

assign co = c[4];

endmodule