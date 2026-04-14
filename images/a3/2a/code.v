module top_module(
  data1_i,
  data2_i,
	select_i,
	data_o
);input [7:0] data1_i;
input [7:0] data2_i;
input       select_i;
output [7:0] data_o;
reg [7:0] out;

assign data_o = out[7:0];
always@(*) begin
  if(!select_i)
		begin
		  out = data2_i;
		end
	else
	  begin
		  out = data1_i;
		end
end

endmodule