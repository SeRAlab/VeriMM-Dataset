module top_module(
		
		input wire iSTATE_NORMAL,
		
		input wire iPREV_VALID,
		input wire iPREV_EX_BRANCH,
		input wire iPREV_BRANCH_PREDICT_ENA,
		input wire [31:0] iPREV_BRANCH_PREDICT_ADDR,
		
		input wire iPREV_BRANCH_VALID,
		input wire iPREV_BRANCH_IB_VALID,
		input wire [31:0] iPREV_JUMP_ADDR,
		
		input wire iNEXT_BUSY,
		output wire oNEXT_PREDICT_HIT
	);reg predict_hit;

	always @* begin
		if(iSTATE_NORMAL)begin	
			if(iPREV_VALID && iPREV_EX_BRANCH && !iNEXT_BUSY)begin
				
				if(iPREV_BRANCH_VALID)begin
					
					`ifdef MIST1032ISA_BRANCH_PREDICT
						
						if(iPREV_BRANCH_PREDICT_ENA)begin
							if(iPREV_BRANCH_PREDICT_ADDR == iPREV_JUMP_ADDR)begin
								predict_hit = 1'b1;
							end
							else begin
								predict_hit = 1'b0;
							end
						end
						
						else begin
							predict_hit = 1'b0;
						end
					`else
						predict_hit = 1'b0;
					`endif

				end
				
				else if(iPREV_BRANCH_IB_VALID)begin
					predict_hit = 1'b0;
				end
				
				else begin
					
					`ifdef MIST1032ISA_BRANCH_PREDICT
						predict_hit = 1'b0;
					`else
					
						predict_hit = 1'b0;
					`endif
				end
			end
		end
		else begin
			predict_hit = 1'b0;
		end
	end


	assign oNEXT_PREDICT_HIT = predict_hit;

endmodule