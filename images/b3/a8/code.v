module top_module (
  input clk,
  input reset,
  input in,
  output reg detected);parameter S0 = 2'b00, S1 = 2'b01, S2 = 2'b10, S3 = 2'b11;
reg [1:0] state;
always @(posedge clk or posedge reset) begin
	if (reset)
		state <= S0;
	else
		case (state)
			S0: state <= in ? S1 : S0;
			S1: state <= in ? S1 : S2;
			S2: state <= in ? S3 : S0;
			S3: state <= in ? S1 : S2;
		endcase
end
always @(*) begin
	detected = (state == S3);
end
endmodule