module top_module(input clk,rst,
 output [3:0]q);reg [3:0]w=4'd0;

always @ (posedge clk,negedge rst)
begin
	if(rst)
	begin
		case(w)
		4'd0: w<=4'd1;
		4'd1: w<=4'd3;
		4'd3: w<=4'd7;
		4'd7: w<=4'd9;
		4'd9: w<=4'd11;
		4'd11: w<=4'd13;
		4'd13: w<=4'd14;
		4'd14: w<=4'd0;
		endcase
	end
	else
	w<=4'd0;
end

assign q=w;

endmodule