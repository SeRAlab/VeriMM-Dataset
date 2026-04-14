module top_module(Dout, Din, EN, Clock, Reset)	;output	[47:0]	Dout	;
reg	[47:0]	Dout	;

input	[47:0]	Din	;
wire	[47:0]	Din	;

input	EN	;
wire	EN	;

input	Clock, Reset	;
wire	Clock, Reset	;

always	@(posedge	Clock)
	begin
		if ( Reset == 1'b0 )
			begin
				Dout <= 48'h0000_0000_0000	;
			end
		else if ( EN == 1'b1 )
			begin
				Dout <= Din	;
			end
		else
			begin
				Dout <= Dout	;
			end
	end

endmodule