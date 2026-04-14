module sq_pg(
	input clk,
	input reset_n,
	input [10:0] fnumber,
	input [2:0] block,
  input [3:0] multiple,
  input ce_n, 
	output [9:0]phase );
reg [19:0] count;
assign phase = count[19:10];
wire [19:0]fmult = fnumber << (block-1);
always @(posedge clk or negedge reset_n ) begin
	if( !reset_n )
		count <= 20'b0;
	else begin
	  if( !ce_n )
  	  count <= count + ( multiple==4'b0 ? fmult>> 1 : fmult*multiple);
  	else 
  	  count <= count;
	end
end
endmodule