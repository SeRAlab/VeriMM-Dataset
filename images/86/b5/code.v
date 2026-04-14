module top_module(
	
	input [31:0]	data_rs1	,
	input [31:0]	data_rs2	,

	input [2:0]		funct3		,

	output	reg		jmpb

);always@(*) begin
		case(funct3)
			3'b000:  	jmpb <= (data_rs1 == data_rs2) ? 1'b1 : 1'b0;	
			3'b001:  	jmpb <= (data_rs1 == data_rs2) ? 1'b0 : 1'b1;	
			3'b100:		begin											
					 		if(data_rs1[31]==data_rs2[31]) begin
					 			jmpb <= (data_rs1 < data_rs2) ? 1'b1 : 1'b0;
					 		end
					 		else begin
					 			jmpb <= data_rs1[31];
					 		end
					 	end	
			3'b101:  	begin											
					 		if(data_rs1[31]==data_rs2[31]) begin
					 			jmpb <= (data_rs1 < data_rs2) ? 1'b0 : 1'b1;
					 		end
					 		else begin
					 			jmpb <= data_rs2[31];
					 		end
					 	end	
			3'b110:  	jmpb <= (data_rs1 < data_rs2) ? 1'b1 : 1'b0;	
			3'b111:  	jmpb <= (data_rs1 > data_rs2) ? 1'b1 : 1'b0;	
			default:  	jmpb <= 1'b0;
		endcase
	end



endmodule