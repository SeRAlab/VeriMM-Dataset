module top_module(
 input enable,
 input clk,
 input reset,
 output [3 : 0] count
 );reg [3 : 0] cnt;
always@(posedge clk) begin
if (reset == 1'b1)
    cnt <= 0;
else if (enable == 1'b1) begin
    if (cnt == 12)
        cnt <= 0;
    else 
        cnt <= cnt + 1;
end
end
assign count = cnt;
endmodule