module top_module(	
	input					sys_clk_50m,ch_c,
	output	reg	[63:0]	freq_reg,
	input					sys_rst_n
	);reg	Gate_1S;			
	wire	Load;
	reg	EN_FT;
	reg	CLR;

	parameter	HIGH_TIME_Gate_1S  	= 	50_000_000;
	parameter	LOW_TIME_Gate_1S   	= 	100_000_000;

	reg [31:0] count;
	always@(posedge sys_clk_50m or negedge sys_rst_n)begin
		if(!sys_rst_n)begin
			count <= 32'b0;
			Gate_1S <= 1'b0;
			end
		else begin
			count <= count + 1'b1;
			if(count == HIGH_TIME_Gate_1S)
				Gate_1S <= 1'b0;
			else if(count == LOW_TIME_Gate_1S)begin 
				count 	<= 32'b1;
				Gate_1S 	<= 1'b1;
				end
			end
		end

	always@(posedge ch_c)
		CLR  <= Gate_1S | EN_FT;
		
	always@(posedge ch_c or negedge sys_rst_n)begin
		if(!sys_rst_n)begin
			EN_FT = 0;
			end
		else begin
			EN_FT = Gate_1S;
			end
		end
	assign	Load = !EN_FT;

	reg	[63:0]	FT_out;	
	always @(posedge ch_c or negedge CLR)begin
		if(!CLR)begin			
			FT_out <= 64'b0;
			end
		else if(EN_FT)begin	
				FT_out <= FT_out + 1'b1;
			end
		end














	
	always@(posedge Load)begin
		
		freq_reg <= FT_out;
		end

	
endmodule