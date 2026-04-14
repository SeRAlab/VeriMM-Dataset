module top_module(Alu_in1,Alu_in2,Alu_sel,Alu_zero_flg,Alu_out
    );parameter wrd_size = 8,
	           sel_width= 3;
	input [wrd_size-1:0] Alu_in1,Alu_in2;
	input [sel_width-1:0] Alu_sel;
	output reg [wrd_size-1:0] Alu_out;
	output  Alu_zero_flg;
	localparam NOP = 3'b000,
	           ADD = 3'b001,
				  SUB = 3'b010,
	           AND = 3'b011,
				  OR  = 3'b100,
              SLT = 3'b101,
				  SRT = 3'b110,				  
				  NOT = 3'b111;
				  				  
	assign Alu_zero_flg = ~|Alu_out;
			  
	
always @(*)
case(Alu_sel)
           NOP:  Alu_out = 0;
			  AND:  Alu_out = Alu_in1&Alu_in2;
			  OR:   Alu_out = Alu_in1|Alu_in2;
			  ADD:  Alu_out = Alu_in1+Alu_in2;
			  SUB:  Alu_out = Alu_in1-Alu_in2;
			  NOT:  Alu_out = ~Alu_in1;
			  SLT:  Alu_out =  Alu_in1<<Alu_in2;
			  SRT:  Alu_out =  Alu_in1>>Alu_in2;
			  default: Alu_out = 0;
			  endcase



endmodule