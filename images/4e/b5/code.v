module top_module(
		
		input wire [3:0] iSRC_MASK,
		input wire [31:0] iSRC_DATA,
		
		output wire [3:0] oDEST_MASK,
		output wire [31:0] oDEST_DATA
	);assign oDEST_MASK = iSRC_MASK;
	assign oDEST_DATA = func_data(iSRC_MASK, iSRC_DATA);
	

	
	
	function [31:0] func_data;
		input [3:0] func_little_bytemask;
		input [31:0] func_src_data; 
		begin
			if(func_little_bytemask == 4'hf)begin
				func_data = {func_src_data[7:0], func_src_data[15:8], func_src_data[23:16], func_src_data[31:24]};
			end
			
			else if(func_little_bytemask == 4'b0011)begin
				
				func_data = {16'h0, func_src_data[7:0], func_src_data[15:8]};
			end
			else if(func_little_bytemask == 4'b1100)begin
				
				func_data = {func_src_data[23:16], func_src_data[31:24], 16'h0};
			end

			else if(func_little_bytemask == 4'b0001)begin
				func_data = {24'h0, func_src_data[7:0]};
			end
			else if(func_little_bytemask == 4'b0010)begin
				func_data = {16'h0, func_src_data[15:8], 8'h0};
			end
			else if(func_little_bytemask == 4'b0100)begin
				func_data = {8'h0, func_src_data[23:16], 16'h0};
			end
			
			else begin
				func_data = {func_src_data[31:24], 24'h0};
			end
		end
	endfunction
endmodule