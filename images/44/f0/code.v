module top_module(Clock, Reset, Set, Enable, In, Out);parameter				Width = 				32,
							Initial =				{Width{1'bx}},
							AsyncReset =			0,
							AsyncSet =				0,
							ResetValue =			{Width{1'b0}},
							SetValue =				{Width{1'b1}};
	

	
	
	
	input					Clock, Enable, Reset, Set;
	input	[Width-1:0]		In;
	output reg [Width-1:0]	Out =					Initial ;
	

	
	
	
	generate if (AsyncReset) begin:AR
		if (AsyncSet) begin:AS
			always @ (posedge Clock or posedge Reset or posedge Set) begin
				if (Reset) Out <=					ResetValue;
				else if (Set) Out <=				SetValue;
				else if (Enable) Out <=				In;
			end
		end else begin:SS
			always @ (posedge Clock or posedge Reset) begin
				if (Reset) Out <=					ResetValue;
				else if (Set) Out <=				SetValue;
				else if (Enable) Out <=				In;
			end
		end
	end else begin:SR
		if (AsyncSet) begin:AS
			always @ (posedge Clock or posedge Set) begin
				if (Reset) Out <=					ResetValue;
				else if (Set) Out <=				SetValue;
				else if (Enable) Out <=				In;
			end
		end else begin:SS
			always @ (posedge Clock) begin
				if (Reset) Out <=					ResetValue;
				else if (Set) Out <=				SetValue;
				else if (Enable) Out <=				In;
			end
		end
	end endgenerate
	
endmodule