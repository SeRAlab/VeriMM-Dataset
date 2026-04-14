module top_module(
	ALUOp,	
	FUNC,		
	OP			
);input wire  [1:0] ALUOp;
	input wire  [5:0] FUNC;
	output wire [2:0] OP;
	
	wire LS, BEQ, R;
	wire OP_ADD, OP_SUB, OP_AND, OP_OR, OP_SLT;
	
	assign LS  = ~ALUOp[0] & ~ALUOp[1];
	assign BEQ =  ALUOp[0] & ~ALUOp[1];
	assign R   = ~ALUOp[0] &  ALUOp[1];

	assign OP_ADD = LS  | (FUNC[5] & ~FUNC[4] & ~FUNC[3] & ~FUNC[2] & ~FUNC[1] & ~FUNC[0] & R);
	assign OP_SUB = BEQ | (FUNC[5] & ~FUNC[4] & ~FUNC[3] & ~FUNC[2] &  FUNC[1] & ~FUNC[0] & R);
	
	assign OP_OR  = FUNC[5] & ~FUNC[4] & ~FUNC[3] &  FUNC[2] & ~FUNC[1] &  FUNC[0] & R;
	assign OP_NOR = FUNC[5] & ~FUNC[4] & ~FUNC[3] &  FUNC[2] &  FUNC[1] &  FUNC[0] & R;
	
	assign OP[2] =  OP_SUB | OP_NOR;
	assign OP[1] =  OP_ADD | OP_SUB;
	assign OP[0] =  OP_OR;


endmodule