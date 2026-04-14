module top_module(
	input wire [3:0] A, B,
	input wire [3:0] ex_rd, mem_rd,
	input wire ctrl_ex, ctrl_mem,
	output reg [1:0] A_sel, B_sel
    );localparam [1:0]	DATA = 2'b00,
							EX = 2'b01,
							MEM = 2'b10;
	
	always @ * begin
		if(ctrl_mem) begin
			if(mem_rd == A) begin
					A_sel = MEM;
					B_sel = DATA;
			end
			else if(mem_rd == B) begin
					A_sel = DATA;
					B_sel = MEM; 
			end
			else begin
				A_sel = DATA;
				B_sel = DATA;
		end
			
		end
		else if( ctrl_ex) begin
			if(ex_rd == A) begin
					A_sel = EX;
					B_sel = DATA;
			end
			else if(ex_rd == B) begin
					A_sel = DATA;
					B_sel = EX; 
			end
			else begin
				A_sel = DATA;
				B_sel = DATA;
		end
			
		end
		else begin
				A_sel = DATA;
				B_sel = DATA;
		end
	end

endmodule