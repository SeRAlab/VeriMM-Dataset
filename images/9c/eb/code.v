module top_module(i_op1, i_op2, i_control, o_result, o_zf);localparam AND = 4'b0000, OR = 4'b0001, ADD = 4'b0010;
localparam SUB = 4'b0110, SOLT = 4'b0111, NOR = 4'b1100; 
  
input       [31:0]  i_op1, i_op2;
input       [3:0]   i_control;
output  reg [31:0]  o_result;
output              o_zf;
  
assign o_zf = !o_result;

always @(*) begin 
	case (i_control)
		AND:  begin 
				o_result <= i_op1 & i_op2;
			  end
		OR:   begin
				o_result <= i_op1 | i_op2;
			  end
		ADD:  begin
				o_result <= i_op1 + i_op2;
			  end
		SUB:  begin 
				o_result <= i_op1 - i_op2;
			  end
		SOLT: begin
				o_result <= (i_op1 < i_op2);
			  end
		NOR:  begin
				o_result <= ~(i_op1 | i_op2);
			  end	
		default : o_result <= 32'b1;
	endcase
end
  
endmodule