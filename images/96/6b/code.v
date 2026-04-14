module top_module(value, carry, clk, rst_n, inc, ld_def, def_value);output [3:0]value;
output carry;
input clk;
input rst_n;
input inc;
input [3:0]def_value;
input ld_def;
reg [3:0]value_tmp;
reg carry;
reg [3:0]value;

always@*
	if(ld_def==1'd1)
		begin
		value_tmp=def_value;
		end
	else if(inc==1'd0)
		begin
		value_tmp=value;
		end
	else if((inc==1'd1) && (value==4'd9))
		begin
		value_tmp=4'd0;
		end
	else
		begin
		value_tmp=value+4'd1;
		end
		
always@(inc or value)
	if((inc==1'd1)&&(value==4'd9))
		begin
		carry=1'd1;
		end
	else
		begin
		carry=1'd0;
		end
		

always@(posedge clk or negedge rst_n)
	if(~rst_n)
		begin
		value<=def_value;
		end
	else
		begin
		value<=value_tmp;
		end

endmodule