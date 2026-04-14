module moore_fsm (
  input clk,
  input reset,
  input x,
  output reg y);parameter S0=2'b00, S1=2'b01, S2=2'b10, S3=2'b11;
	reg [1:0] state, next_state;

	always @(posedge clk) begin
		if (reset) state <= S0;
		else state <= next_state;
	end
	
	always @(*) begin
		case (state)
			S0: next_state = x ? S2 : S1;
			S1: next_state = x ? S0 : S3;
			S2: next_state = x ? S3 : S0;
			S3: next_state = x ? S1 : S2;
			default: next_state = S0;
		endcase
	end
	
	always @(state) begin
		case (state)
			S0: y = 1;
			S1: y = 0;
			S2: y = 1;
			S3: y = 0;
			default: y = 0;
		endcase
	end
	
endmodule