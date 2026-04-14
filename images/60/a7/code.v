module top_module(d,clk,clrn,q
    );input [1:0] d;
	 input clk,clrn;
	 output [1:0] q;
    reg [1:0] q;
    always @ (posedge clk or negedge clrn) begin
			if (clrn == 0) q <= 0;
			else				q <= d;
	 end	 
endmodule