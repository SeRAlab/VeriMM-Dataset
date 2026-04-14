module top_module(x, y, clk, reset, state_out);input wire x, clk, reset;


output wire y;
output wire [2:0] state_out;


reg [2:0] State;
reg [2:0] NextState;


localparam 	STATE_Initial = 3'b000,
			STATE_1 = 3'b001,
		 	STATE_2 = 3'b010,
			STATE_3 = 3'b011,
			STATE_4 = 3'b100,
			STATE_5 = 3'b101,
			STATE_6 = 3'b110,
			STATE_7_UNUSED = 3'b111;


always @(posedge clk) begin
	if (reset) State <= STATE_Initial;
	else State <= NextState;
end


assign y = (State == STATE_5) | (State == STATE_6);
assign state_out = State;



always @(*) begin
	NextState = State;
	case (State) 
		STATE_Initial: begin
			if (x) NextState = STATE_1;
			else NextState = STATE_Initial;
		end
		STATE_1 : begin
			if (x) NextState = STATE_1;
			else NextState = STATE_2;
		end
		STATE_2 : begin
			if (x) NextState = STATE_3;
			else NextState = STATE_Initial;
		end
		STATE_3 : begin
			if (x) NextState = STATE_4;
			else NextState = STATE_2;
		end
		STATE_4 : begin
			if (x) NextState = STATE_5;
			else NextState = STATE_6;
		end
		STATE_5 : begin
			if (x) NextState = STATE_1;
			else NextState = STATE_2;
		end
		STATE_6 : begin
			if (x) NextState = STATE_3;
			else NextState = STATE_Initial;
		end
		STATE_7_UNUSED : begin
			NextState = STATE_Initial;
		end
	endcase
end

endmodule