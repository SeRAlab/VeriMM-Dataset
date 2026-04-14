module top_module(input  clk, reset,  z, input [2:0] inst_op,  output reg  ir_write, B_write, pc_src, pc_write, mem_src, mem_write, stack_src, tos, push, pop);parameter [2:0] IF = 3'b000, ID = 3'b001, POP_B = 3'b010, POP_A = 3'b011, PUSH_ALU = 3'b100, PUSH_INST = 3'b101, POP_INST =  3'b110, JMP = 3'b111; 
	reg [2:0] c_state = IF, n_state;
	parameter [2:0] OP_ADD = 3'b000, OP_SUB = 3'b001, OP_AND = 3'b010, OP_NOT = 3'b011, OP_PUSH = 3'b100, OP_POP = 3'b101,OP_JMP = 3'b110, OP_JZ = 3'b111;
	
	always @(posedge clk) 
	begin
		if(!reset)
			c_state = n_state;
		else c_state = IF;
	end
		
	always @(c_state, z , inst_op) begin 
		n_state = 0;
		
		case (c_state)
			IF: begin
				n_state = ID;
			end
			ID: begin
				case(inst_op)
					
					OP_ADD: n_state = POP_B;
					OP_AND: n_state = POP_B;
					OP_SUB: n_state = POP_B;
					OP_NOT: n_state = POP_A;
					
					OP_PUSH: n_state = PUSH_INST;
					OP_POP: n_state = POP_INST;
					
					OP_JMP: n_state = JMP;
					OP_JZ: n_state = z ? JMP : IF;
				endcase
			end
			POP_B: begin
				n_state = POP_A;
			end
			POP_A: begin
				n_state = PUSH_ALU;
			end
			PUSH_ALU: begin
				n_state = IF;
			end
			PUSH_INST: begin
				n_state = IF;
			end
			POP_INST: begin
				n_state = IF;
			end
			JMP: begin
				n_state = IF;
			end
		endcase
	end
	
	always @ (c_state) begin
		{ir_write, B_write, pc_src, pc_write, mem_src, mem_write, stack_src, tos, push, pop}  = 0;
		case (c_state)
			IF: begin
				{mem_src, pc_src, pc_write, ir_write} = 4'b1111;
			end
			ID: begin
				tos = 1'b1;
			end
			POP_B: begin
				{tos,pop} = 2'b11;
			end
			POP_A: begin
				{tos,pop} = 2'b11;
			end
			PUSH_ALU: begin
				{stack_src,push} = 2'b11;
			end
			PUSH_INST: begin
				push = 1'b1;
				{mem_src, stack_src} = 2'b00;
			end
			POP_INST: begin
				{tos, pop, mem_write} = 3'b111;
				pc_src = 1'b0;
			end
			JMP: begin
				pc_write = 1'b1;
				pc_src = 1'b0;
			end
		endcase	
	end
endmodule