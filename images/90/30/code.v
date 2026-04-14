module top_module(

low_clk,
clk, 
rst_n, 
note_div, 
audio_left, 
audio_right, 

);input low_clk;
input clk; 
input rst_n; 
input [19:0] note_div; 
output [15:0] audio_left; 
output [15:0] audio_right; 



reg [19:0] clk_cnt_next, clk_cnt;
reg b_clk, b_clk_next;





always @(posedge clk or negedge rst_n)
if (~rst_n)
begin
clk_cnt <= 20'd0;
b_clk <= 1'b0;
end
else
begin
clk_cnt <= clk_cnt_next;
b_clk <= b_clk_next;
end
always @*
if (clk_cnt == note_div)
begin
clk_cnt_next = 20'd0;
b_clk_next = ~b_clk;
end
else
begin
clk_cnt_next = clk_cnt + 1'b1;
b_clk_next = b_clk;
end





assign audio_left = (b_clk == 1'b0) ? 16'hC000 : 16'h3FFF;
assign audio_right = (b_clk == 1'b0) ? 16'hC000 : 16'h3FFF;
endmodule