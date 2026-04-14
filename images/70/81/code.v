module top_module(
    input clk,
    input rst,
    input [3:0] a,
    input [3:0] b,
    input cin,
    output [3:0] sum,
    output cout
);reg [3:0] sum_reg;
reg cout_reg;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        sum_reg <= 4'b0;
        cout_reg <= 1'b0;
    end else begin
        sum_reg <= a + b + cin;
        cout_reg <= sum_reg[4];
    end
end

assign sum = sum_reg;
assign cout = cout_reg;

endmodule