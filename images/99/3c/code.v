module top_module(CLK, reset, X, Out);input CLK, reset, X;
	output reg [3:0] Out;
	reg [1:0] state, next_state;
	parameter S0=2'b00, S1=2'b01, S2=2'b10, S3=2'b11;

	
	
	always @(posedge CLK or posedge reset)
	begin
		if (reset)
			state <= S0;
		else
			state <= next_state;
	end

	
	always @(X or state)
	begin
		case (state)
			S0: next_state = X ? S1 : S3;
			S1: next_state = X ? S2 : S0;
			S2: next_state = X ? S3 : S1;
			S3: next_state = X ? S0 : S2;
		endcase
	end

	
	always @(X or state)
	begin
		case (state)
			S0: Out = 4'b0001;
			S1: Out = 4'b0010;
			S2: Out = 4'b0100;
			S3: Out = 4'b1000;
		endcase
	end

endmodule