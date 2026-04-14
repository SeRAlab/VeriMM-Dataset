module top_module(ra1, ra2, wa, wd, RegWrite, clk, rd1, rd2);input [2:0] ra1;
    input [2:0] ra2;
    input [2:0] wa;
    input [15:0] wd;
    input RegWrite; 
	 input clk;
    output reg [15:0] rd1;
    output reg [15:0] rd2;
	 
	 
	 reg [15:0] regs [0:7]; 
	 
	 
	 always @ (posedge clk) begin
				if (ra1 == 3'b000) begin  
					rd1 = 16'h0; 
				end else begin
					rd1 = regs[ra1]; 
				end
		end	
	
	 always @ (posedge clk) begin
				if (ra2 == 3'b000) begin
					rd2 = 16'h0;
				end else begin
					rd2 = regs[ra2];
				end
		end
		
		  
	always @(posedge clk) begin
		if (RegWrite == 1'b1)
			if (wa!= 2'h0) begin
				regs[wa] = wd;
			end
	end
endmodule