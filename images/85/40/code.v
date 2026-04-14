module top_module(
input			clk,
input	[3:0]	bts,
input	[3:0]	curFlr,
output			dir
);reg 		fdir;
reg [3:0]	pbts;
assign dir = fdir;
always@ (posedge clk)
	fdir = (pbts>curFlr);

always@ (*)
begin
	if(dir)
		casex(bts)
			4'b1XXX:pbts = 4'b1000;
			4'b01XX:pbts = 4'b0100;
			4'b001X:pbts = 4'b0010;
			4'b0001:pbts = 4'b0001;
			default:pbts = curFlr;
		endcase
	else
		casex(bts)
			4'bXXX1:pbts = 4'b0001;
			4'bXX10:pbts = 4'b0010;
			4'bX100:pbts = 4'b0100;
			4'b1000:pbts = 4'b1000;
			default:pbts = curFlr;
		endcase
end

endmodule