module top_module(
input wire clk,
input wire reset,
output wire error,
input wire prbs_in
);reg [22:0] col ;
wire      fb;
always@(posedge clk or posedge reset)

begin
	if(reset)
		begin
			col<=23'b1111_1111_1111_1111_1111_111;
		end
	else
		begin
			col<={prbs_in,col[22:1]};
		end
end
assign fb=(col[4]^col[22]);
assign error=(fb^prbs_in);

endmodule