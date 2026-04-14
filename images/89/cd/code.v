module top_module( source1,source2,ALU_CTRL,result);input [15:0] source1;
    input [15:0] source2;
    input [3:0] ALU_CTRL;
    output [15:0] result;
	 
	      
	reg [15:0] result;    

	
	

	parameter 
		op_add = 4'b0010,
		op_sub = 4'b0110,
		op_slt = 4'b0111;

	always@(*) begin
		case(ALU_CTRL)
			op_add:
				begin
					result = source1 + source2;
				end
			op_sub:
				begin
					result = source1 - source2;
				end
			op_slt:
				begin
					result = (source1 < source2) ? 1 : 0;
				end
		endcase 
	end
	

endmodule