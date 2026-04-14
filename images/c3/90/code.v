module Adder_4bit (
    input clk,
    input rst,
    input [3:0] a,
    input [3:0] b,
    input cin,
    output [3:0] sum,
    output cout
);

reg [3:0] sum_reg;
reg cout_reg;

always @(posedge clk or negedge rst) begin
    if (rst == 0) begin
        sum_reg <= 4'b0;
        cout_reg <= 1'b0;
    end
    else begin
        sum_reg <= a + b + cin;
        cout_reg <= (a[3] & b[3]) | (a[3] & cin) | (b[3] & cin);
    end
end

assign sum = sum_reg;
assign cout = cout_reg;

endmodule