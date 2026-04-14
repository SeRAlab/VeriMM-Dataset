module top_module(
    input clk,
    input reset,
    input [15:0] a,
    input [15:0] b,
    input cin,
    output [15:0] sum,
    output cout
);reg [15:0] sum_reg;
reg cout_reg;

always @(posedge clk) begin
    if (reset) begin
        sum_reg <= 16'd0;
        cout_reg <= 1'b0;
    end else begin
        sum_reg <= a + b + cin;
        cout_reg <= (sum_reg[16] == 1);
    end
end

assign sum = sum_reg;
assign cout = cout_reg;

endmodule