module top_module(
RESET_N,
BAUD_CLK,
RX_DATA,
RX_BUFFER,

RX_WORD,
RX_PAR_DIS,
RX_PARITY,
PARITY_ERR,

FRAME,
READY
);input					RESET_N;
input					BAUD_CLK;
input					RX_DATA;
output	[7:0]		RX_BUFFER;
reg		[7:0]		RX_BUFFER;
input					RX_WORD;
input					RX_PAR_DIS;
input					RX_PARITY;
output				PARITY_ERR;
reg					PARITY_ERR;
output				FRAME;
reg					FRAME;
output				READY;
reg					READY;
reg		[5:0]		STATE;
reg		[2:0]		BIT;

reg					RX_DATA0;
reg					RX_DATA1;

always @ (posedge BAUD_CLK or negedge RESET_N)
begin
	if(!RESET_N)
	begin
		RX_BUFFER <= 8'h00;
		STATE <= 6'b000000;
		FRAME <= 1'b0;
		BIT <= 3'b000;
		RX_DATA0 <= 1'b1;
		RX_DATA1 <= 1'b1;
		READY <= 1'b0;
	end
	else
	begin
		RX_DATA0 <= RX_DATA;
		RX_DATA1 <= RX_DATA0;
		case (STATE)
		6'b000000:
		begin
			BIT <= 3'b000;
			if(~RX_DATA1)
				STATE <= 6'b000001;
		end
		6'b001111:								
		begin										
			READY <= 1'b0;
			STATE <= 6'b010000;
		end
		6'b010111:								
		begin
			RX_BUFFER[BIT] <= RX_DATA1;
			STATE <= 6'b011000;
		end
		6'b011111:								
		begin
			if(BIT == 3'b111)
				STATE <= 6'b100000;
			else
			begin
				if((BIT == 3'b110) && !RX_WORD)
					STATE <= 6'b100000;
				else
				begin
					BIT <= BIT + 1'b1;
					STATE <= 6'b010000;
				end
			end
		end
		6'b100000:							
		begin
			if(RX_PAR_DIS)
				STATE <= 6'b110001;		
			else
				STATE <= 6'b100001;		
		end
		6'b100111:							
		begin
			PARITY_ERR <=((((RX_BUFFER[0] ^ RX_BUFFER[1])
							 ^  (RX_BUFFER[2] ^ RX_BUFFER[3]))
							 ^ ((RX_BUFFER[4] ^ RX_BUFFER[5])
							 ^  (RX_BUFFER[6] ^ (RX_BUFFER[7] & RX_WORD))))	
							 ^  (RX_PARITY ^ RX_DATA1));
			STATE <= 6'b101000;
		end
		6'b110111:							
		begin
			READY <= 1'b1;					
			FRAME <= !RX_DATA1;			
			STATE <= 6'b111000;
		end

		6'b111000:
		begin
			if(RX_DATA1)						
				STATE <= 6'b000000;
		end
		default: STATE <= STATE + 1'b1;
		endcase
	end
end

endmodule