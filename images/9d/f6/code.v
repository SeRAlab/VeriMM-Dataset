module top_module( 
	output reg [79:0] keyboard_o,
	
	input busclk_i,	
	input nreset_i,
	input [3:0] A_i,	
	input [7:0] D_i,
	output reg [7:0] D_o,
	input nWR_i,
	input nRD_i	
	);reg [79:0] keyboard;
	
	
	
	
	
	
	
	
	always @(posedge busclk_i)
	begin
		if( !nreset_i ) begin
			keyboard <= 80'd0;
			keyboard_o <= ~(80'd0);
		end
		else begin
			if( !nRD_i ) begin
				D_o <= 	(A_i == 4'd0) ? keyboard[7:0] :
							(A_i == 4'd1) ? keyboard[15:8] :
							(A_i == 4'd2) ? keyboard[23:16] :
							(A_i == 4'd3) ? keyboard[31:24] :
							(A_i == 4'd4) ? keyboard[39:32] :
							(A_i == 4'd5) ? keyboard[47:40] :
							(A_i == 4'd6) ? keyboard[55:48] :
							(A_i == 4'd7) ? keyboard[63:56] :
							(A_i == 4'd8) ? keyboard[71:64] :
							(A_i == 4'd9) ? keyboard[79:72] : 
							8'd0;
			end
			if( !nWR_i ) begin
				if( A_i > 4'd9 ) begin		
					if( D_i[7] ) begin
						keyboard <= 80'd0;
						keyboard_o = ~(80'd0);
					end
					else
						if( D_i[0] )
							keyboard_o <= ~keyboard;
				end
				else
				keyboard <= {
							(A_i != 4'd9) ? keyboard[79:72] : D_i,
							(A_i != 4'd8) ? keyboard[71:64] : D_i,
							(A_i != 4'd7) ? keyboard[63:56] : D_i,
							(A_i != 4'd6) ? keyboard[55:48] : D_i,
							(A_i != 4'd5) ? keyboard[47:40] : D_i,
							(A_i != 4'd4) ? keyboard[39:32] : D_i,
							(A_i != 4'd3) ? keyboard[31:24] : D_i,
							(A_i != 4'd2) ? keyboard[23:16] : D_i,
							(A_i != 4'd1) ? keyboard[15:8] : D_i,
							(A_i != 4'd0) ? keyboard[7:0] : D_i
									};
			end
		end
	end
endmodule