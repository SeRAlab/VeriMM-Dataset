module top_module(
	dig1,
	dig2,
	dig3,
	dig4,
	sec1,
	sec0,
	min1,
	min0,
	alu,
	clk,
	rst_n,
	switch
    );output [3:0]dig1;
output [3:0]dig2;
output [3:0]dig3;
output [3:0]dig4;

input [3:0]sec1;
input [3:0]sec0;
input [3:0]min1;
input [3:0]min0;
input [1:0]alu;
input clk,switch;
input rst_n;

reg[3:0]dig1,dig2,dig3,dig4;
reg[3:0]dig1_next,dig2_next,dig3_next,dig4_next;

always@*
if (switch==1'b0&&alu==2'b10)
begin
dig1_next = dig1;
dig2_next = dig2;
dig3_next = dig3;
dig4_next = dig4;
end
else
begin
dig1_next = min1;
dig2_next = min0;
dig3_next = sec1;
dig4_next = sec0;
end

  always @(posedge clk or negedge rst_n)
  if (~rst_n)
    begin
    dig1 <= 4'd0;
	 dig2 <= 4'd0;
	 dig3 <= 4'd0;
	 dig4 <= 4'd0;
	 end
	 
  else
  begin
  dig1 <= dig1_next ;
  dig2 <= dig2_next ;
  dig3 <= dig3_next ;
  dig4 <= dig4_next ;
  end

endmodule