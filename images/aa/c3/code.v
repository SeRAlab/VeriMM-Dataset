module top_module(iaddr, branch, jump, ins, jiaddr, imm16, imm26, riaddr, niaddr);input 	branch, jump;
	input [31:0] 	ins;
	input [31:0]	jiaddr;
	input [31:0]	iaddr;
	input [15:0] 	imm16;
	input [25:0]	imm26;

	output 	 	[31:0] riaddr;
	output reg 	[31:0] niaddr;

	wire [5:0]	op;
	wire [5:0] 	func;
	assign op 	= ins[31:26];
	assign func = ins[5:0];
	
	parameter 	R 		= 6'b000000,
				J  		= 6'b000010,
				JAL		= 6'b000011,
				ERET	= 6'b010000;
	
	parameter 	JR		= 6'b001000,
				JALR	= 6'b001001,
				SYSCALL = 6'b001100;

	wire [31:0] pc4;

	assign pc4 		= iaddr + 3'b100;
	assign riaddr 	= pc4 + 3'b100;

	always @ ( * ) begin
		if (branch) begin
			
			niaddr = {{14{imm16[15]}}, imm16[15:0], 2'b00} + pc4;

		end else if (jump) begin
			case (op)
				J: begin
					niaddr = {iaddr[31:28], imm26[25:0], 2'b00};
				end
				JAL: begin
					
					niaddr <= {iaddr[31:28], imm26[25:0], 2'b00};
				end
				R: begin
					case (func)
						JR: begin
							niaddr = jiaddr[31:0];
						end
						JALR: begin
							
							niaddr <= jiaddr[31:0];
						end
						SYSCALL: begin
							niaddr <= jiaddr[31:0];
						end
					endcase
				end
				ERET: begin
					niaddr <= jiaddr[31:0];
				end
			endcase

		end else begin
			niaddr = pc4;
		end
	end

endmodule