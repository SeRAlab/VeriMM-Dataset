module top_module(
BAUD_CLK,
RESET_N,
TX_DATA,
TX_START,
TX_DONE,
TX_STOP,
TX_WORD,
TX_PAR_DIS,
TX_PARITY,
TX_BUFFER
);input					BAUD_CLK;
input					RESET_N;
output				TX_DATA;
reg					TX_DATA;
input					TX_START;
output				TX_DONE;
reg					TX_DONE;
input					TX_STOP;
input					TX_WORD;
input					TX_PAR_DIS;
input					TX_PARITY;

input		[7:0]		TX_BUFFER;

reg		[6:0]		STATE;
reg		[2:0]		BIT;
wire					PARITY;
reg					TX_START0;
reg					TX_START1;

assign PARITY =	((TX_BUFFER[0] ^ TX_BUFFER[1])
					^	 (TX_BUFFER[2] ^ TX_BUFFER[3]))
					^	((TX_BUFFER[4] ^ TX_BUFFER[5])
					^	 (TX_BUFFER[6] ^ (TX_BUFFER[7] & TX_WORD))) 
					^	  TX_PARITY;

always @ (negedge BAUD_CLK or negedge RESET_N)
begin
	if(!RESET_N)
	begin
		STATE <= 7'b0000000;
		TX_DATA <= 1'b1;
		TX_DONE <= 1'b1;
		BIT <= 3'b000;
		TX_START0 <= 1'b0;
		TX_START1 <= 1'b0;
	end
	else
	begin
		TX_START0 <= TX_START;
		TX_START1 <= TX_START0;
		case (STATE)
		7'b0000000:
		begin
			BIT <= 3'b000;
			TX_DATA <= 1'b1;
			if(TX_START1)
			begin
				TX_DONE <= 1'b0;
				STATE <= 7'b0000001;
			end
		end
		7'b0000001:
		begin
			TX_DATA <= 1'b0;
			STATE <= 7'b0000010;
		end
		7'b0010001:
		begin
			TX_DATA <= TX_BUFFER[BIT];
			STATE <= 7'b0010010;
		end
		7'b0100000:
		begin
			BIT <= BIT + 1'b1;
			if(BIT != {2'b11, TX_WORD})
				STATE <= 7'b0010001;
			else
				if(!TX_PAR_DIS)
					STATE <= 7'b0100001;				
				else
					STATE <= 7'b0110001;				
		end

		7'b0100001:
		begin
			TX_DATA <= PARITY;
			STATE <= 7'b0100010;
		end

		7'b0110001:
		begin
			TX_DONE <= 1'b1;
			TX_DATA <= 1'b1;
			STATE <= 7'b0110010;
		end

		7'b0111111:
		begin
			if(!TX_STOP)
				STATE <= 7'b1001111;
			else
				STATE <= 7'b1000000;
		end
		7'b1001111:
		begin
			STATE <= 7'b0000000;
		end
		default: STATE <= STATE + 1'b1;
		endcase
	end
end
endmodule