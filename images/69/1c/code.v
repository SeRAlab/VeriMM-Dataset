module top_module(
	 read1, 
	 read2,
	 control, 
	 result,
	 zero
    );input[31:0] read1;
	 input[31:0] read2;
	 input[3:0] control; 
	 output reg [31:0] result; 
	 output reg zero;
	 
	 always @(read1,read2,control) 
		begin 
		case(control)
		4'b0000:  result <= read1 && read2;
		4'b0001: result <= read1 || read2;
		4'b0010: result <= read1 + read2;
		4'b0110: result <= read1 - read2;
		4'b0111: begin
			if (read1 > read2) begin 
				result <= 0; 
			end else begin 
				result <= 1; 
			end
			end 
		4'b1100: result <= ~(read1 || read2);
		default: result <= 0;
		endcase
		if (read1 == read2) begin 
			zero = 1; 
		end else begin 
			zero = 0; 
		end 
	end 
endmodule