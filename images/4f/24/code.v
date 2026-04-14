module top_module(Clk, rdEn, wrEn, addr, wrData, Data);parameter WIDTH = 8;
	parameter DEPTH = 256;
		
	input Clk;
	input rdEn, wrEn;
	input [WIDTH-1:0] wrData;
	input [7:0] addr;
	
	output [WIDTH-1:0] Data;
	
	reg [WIDTH-1:0] data_out;
	
	always @ (posedge Clk)
		begin : INST_MEMORY
			case (addr)
			  
			  
			  
				8'h0: data_out <= 32'h0c_00_09_xx; 
				8'h1: data_out <= 32'h0c_01_04_xx; 
				8'h2: data_out <= 32'h0c_02_00_xx; 
				8'h3: data_out <= 32'h0c_c0_00_xx; 
				8'h4: data_out <= 32'h0c_c1_01_xx; 
				8'h5: data_out <= 32'h0c_c4_04_xx; 
				8'h6: data_out <= 32'h08_10_xx_xx; 
				
				8'h10: data_out <= 32'h01_00_00_01; 
				8'h11: data_out <= 32'h0b_14_00_xx; 
				8'h12: data_out <= 32'h00_02_02_c1; 
				8'h13: data_out <= 32'h08_10_xx_xx; 
				
				8'h14: data_out <= 32'h00_03_00_01; 
				8'h15: data_out <= 32'h0d_fa_03_xx; 
				8'h16: data_out <= 32'h02_fb_03_c4; 
				8'h17: data_out <= 32'h0d_fc_02_xx; 
				8'h18: data_out <= 32'h02_fd_02_c4; 
				8'h19: data_out <= 32'h0f_xx_xx_xx; 
				
				8'h20: data_out <= 32'h09_22_e4_xx; 
				8'h21: data_out <= 32'h0d_00_e0_xx; 
				8'h22: data_out <= 32'h09_24_e1_xx; 
				8'h23: data_out <= 32'h0d_01_e0_xx; 
				8'h24: data_out <= 32'h0d_fa_01_xx; 
				8'h25: data_out <= 32'h02_fb_01_c4; 
				8'h26: data_out <= 32'h0d_fc_00_xx; 
				8'h27: data_out <= 32'h02_fd_00_c4; 
				8'h28: data_out <= 32'h0a_10_e3_xx; 
				8'h29: data_out <= 32'h08_20_xx_xx; 
				
				
				
				default: data_out <= 32'hxx_xx_xx_xx;
			endcase
		end
		
		assign Data = data_out;
endmodule