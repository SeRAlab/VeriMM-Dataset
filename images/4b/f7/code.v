module top_module(
    input [3:0] A,
    input [3:0] B,
    input cin,
    input clk,       // Added clk input
    output reg [3:0] S,
    output reg cout
);reg [3:0] sum1, sum2, sum3;
reg c1, c2, c3;

always @(A, B, cin) begin
    sum1 = A + B + cin;
    c1 = (sum1 > 7) ? 1 : 0;
    sum2 = sum1 - 8;
    c2 = (sum2 > 7) ? 1 : 0;
    sum3 = sum2 - 8;
    c3 = (sum3 > 7) ? 1 : 0;
    S = sum3;                // Moved assignment to within the always block
end

always @(posedge clk) begin
    cout <= c3;
end

endmodule