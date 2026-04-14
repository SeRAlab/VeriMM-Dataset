module top_module(
	input [NUM_BITS-1:0] in,
	input out_resetn,
	input out_clk,
	output [NUM_BITS-1:0] out
);parameter NUM_BITS = 1;


parameter CLK_ASYNC = 1;

reg [NUM_BITS-1:0] out_m1 = 'h0;
reg [NUM_BITS-1:0] out_m2 = 'h0;

always @(posedge out_clk)
begin
	if (out_resetn == 1'b0) begin
		out_m1 <= 'b0;
		out_m2 <= 'b0;
	end else begin
		out_m1 <= in;
	    out_m2 <= out_m1;	
	end
end

assign out = CLK_ASYNC ? out_m2 : in;

endmodule