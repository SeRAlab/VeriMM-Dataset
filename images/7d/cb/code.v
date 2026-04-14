module top_module(in, out);input in;
	output out;
	
   reg [3:0] counter = 0;
	
	assign out = (counter == 0);
	
	always @(posedge in) begin
		if (counter < 9) begin
			counter <= counter + 1;
		end else begin;
			counter <= 0;
		end
	end
	
	
endmodule