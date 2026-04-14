module top_module(
		
	
	input ACQ_EN,
	input ACQ_WND,
	
	output reg TX_SD,
	input RESET,
	input ADC_CLK
	
);reg ACQ_WND_REG;
	always @(ADC_CLK)
	begin
		ACQ_WND_REG <= ACQ_WND;
	end
	

	reg [3:0] State;
	localparam [3:0]
		S0 = 4'b0001,
		S1 = 4'b0010,
		S2 = 4'b0100,
		S3 = 4'b1000;
	always @(posedge ADC_CLK, posedge RESET)
	begin
		if (RESET)
		begin
			
			State <= S0;
			TX_SD <= 1'b0;
			
		end
		else
		begin
		
			case (State)
			
				S0 : 
				begin
				
					TX_SD <= 1'b0;
					if ( ACQ_WND_REG ) State = S1;
					
				end
				
				S1 : 
				begin
					TX_SD <= 1'b1;
					if ( ACQ_EN ) State = S2;
				
				end
				
				S2 : 
				begin
					
					TX_SD <= 1'b1;
					if ( !ACQ_EN ) State = S3;
				
				end
				
				S3 : 
				begin
				
					TX_SD <= 1'b0;
					if ( !ACQ_WND_REG ) State = S0;
				
				end
				
			endcase
		end
	end


endmodule