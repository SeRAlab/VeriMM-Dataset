module top_module(input in, clock, load, output out);reg q;
	assign out = q;
  always @(posedge clock) begin
	  if (load) q = in;
  end
endmodule