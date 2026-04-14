module top_module(
	input clk,
	input gate,
	input clear,
	input b_in,
	output b_out,
	output zero
);parameter wid=16;
parameter poly=16'h1021;
parameter init=16'hffff;

reg [wid-1:0] sr=0;
wire fb=sr[wid-1]^b_in;
always @(posedge clk) if (gate)
	sr <= clear ? init : ({sr[wid-2:0],1'b0} ^ ({wid{fb}} & poly));
assign b_out = sr[wid-1];
assign zero = ~(|sr);
endmodule