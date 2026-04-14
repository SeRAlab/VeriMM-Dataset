module top_module(
	instruction_opcode,
	ex_freeze,
	clk_in,
	data_out,
	reset
	);input	[31:0]	instruction_opcode;
input		ex_freeze;
input		clk_in;
input		reset;
output		data_out;


localparam	STATE_Initial		= 3'd0,
		STATE_1			= 3'd1,
		STATE_2			= 3'd2,
		STATE_3			= 3'd3,
		STATE_4			= 3'd4,
		STATE_5_Placeholder	= 3'd5,
		STATE_6_Placeholder	= 3'd6,
		STATE_7_Placeholder	= 3'd7;	
		

localparam	OPCODE_A		= 32'h15000000,
		OPCODE_B		= 32'h15000000,
		OPCODE_C		= 32'h15000000,
		OPCODE_D		= 32'h15000000;



wire [31:0] instruction_opcode;
wire ex_freeze;
wire clk_in;
wire reset;
reg  data_out;


reg[2:0] CurrentState;
reg[2:0] NextState;



always@ (posedge clk_in)
begin: STATE_TRANS
	if(reset) CurrentState <= STATE_Initial;
	else CurrentState <= NextState;
	
end	


always@ (*)
begin
	if(ex_freeze) begin 
		NextState <= CurrentState;
	end
	else begin
		case(CurrentState)
			STATE_Initial: begin
				if(instruction_opcode == OPCODE_A) NextState <= STATE_1;
				else NextState <= STATE_Initial;
			end	
			STATE_1: begin
				if(instruction_opcode == OPCODE_B) NextState <= STATE_2;
				else NextState <= STATE_Initial;
			end
			STATE_2: begin
				if(instruction_opcode == OPCODE_C) NextState <= STATE_3;
				else NextState <= STATE_Initial;
			end
			STATE_3: begin
				if(instruction_opcode == OPCODE_D) NextState <= STATE_4;
				else NextState <= STATE_Initial;
			end
			STATE_4: begin
				NextState <= STATE_Initial;
			end
			STATE_5_Placeholder: begin
			end
			STATE_6_Placeholder: begin
			end
			STATE_7_Placeholder: begin
			end
		endcase
	end
end


always@ (*)
begin
	data_out = 1'b0;
	if(CurrentState == STATE_4) data_out = 1'b1;
end
endmodule