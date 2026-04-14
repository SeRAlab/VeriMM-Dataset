module top_module(
    input signed [3:0] a,
    input signed [3:0] b,
    output reg signed [7:0] out
);reg signed [3:0] m;
reg signed [4:0] p;
reg signed [4:0] n;
reg signed [8:0] result;

always @(*) begin
    m = {a[3], a};
    p = {b, 1'b0};
    n = {-b, 1'b0};
    result = m * p + n;
end

assign out = result[7:0];

endmodule