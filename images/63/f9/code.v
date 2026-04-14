module top_module(
	input sys_clk,
	
	input first,
	input next,

	input [6:0] hmesh_last,
	input [6:0] vmesh_last,
	
	output [31:0] r0,
	output [31:0] r1,
	output reg last
);reg [6:0] r0r;
assign r0 = {25'd0, r0r};
reg [6:0] r1r;
assign r1 = {25'd0, r1r};

always @(posedge sys_clk) begin
	if(first) begin
		r0r <= 7'd0;
		r1r <= 7'd0;
	end else if(next) begin
		if(r0r == hmesh_last) begin
			r0r <= 7'd0;
			r1r <= r1r + 7'd1;
		end else
			r0r <= r0r + 7'd1;
	end
end


always @(posedge sys_clk)
	last <= (r0r == hmesh_last) & (r1r == vmesh_last);

endmodule