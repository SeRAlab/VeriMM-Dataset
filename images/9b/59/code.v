module top_module(clk,rst_n,adder_a,adder_b,adder_out);parameter data_in_width = 32;
input clk;
input rst_n;
input [data_in_width-1:0] adder_a;
input [data_in_width-1:0] adder_b;
output [data_in_width-1:0]adder_out;

reg [data_in_width:0]sum;

always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        sum <= 0;
    else
        sum <= adder_a + adder_b;
end
assign adder_out = sum[data_in_width - 1:0];

endmodule