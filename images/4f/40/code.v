module top_module(clk, a, b, p);input clk;
input [79:0] a;
input [79:0] b;
output reg [159:0] p;

reg [79:0] p1,p2,p3,p4;
reg [159:0] sum1,sum2,sum3;

always @(posedge clk)
    p1 = a[39:0] * b[39:0];
always @(posedge clk)
    p2 = a[39:0] * b[79:40];
always @(posedge clk)
    p3 = a[79:40] * b[39:0];
always @(posedge clk)
    p4 = a[79:40] * b[79:40];
always @(posedge clk)
    sum1 <= {p4,p1};
always @(posedge clk)
    sum3 <= {p2+p3,40'h0000};
always @(posedge clk)
    p <= sum1 + sum3;endmodule