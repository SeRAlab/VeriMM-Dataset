module top_module(clk,clk_div);input clk;
    output clk_div;
    parameter n = 26;
    reg[n-1:0]num;
    wire[n-1:0]next_num;
    always@(posedge clk)begin
        num <= next_num;
    end
    assign next_num = num + 1;
    assign clk_div = num[n-1];endmodule