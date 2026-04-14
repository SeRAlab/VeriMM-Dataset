module top_module(
    input [3:0] a,
    input [3:0] b,
    input cin,
    output [3:0] sum,
    output cout
);reg [3:0] sum_reg;
reg cout_reg;

always @(*) begin
    sum_reg = a + b + cin;
    cout_reg = ((a[3] & b[3]) | (a[3] & cin) | (b[3] & cin));
end

assign sum = sum_reg;
assign cout = cout_reg;

endmodule