module top_module(qout,MSBout,LSBout,data,sel,reset,clock);output [3:0] qout;
	output MSBout,LSBout;
	input [3:0] data;
	input [1:0] sel;
	input clock,reset;
	reg [3:0] qout;
	
	assign MSBout = qout[3];
	assign LSBout = qout[0];
	
	always @(posedge clock) begin
	if (reset ===0) qout<=0;
	else begin
	case(sel)
	0: qout <= qout;
	1: qout <={qout[0],qout[3:1]};
	2: qout <={qout[2:0],qout[3]};
	3: qout <=data;
	endcase
 end
end
endmodule