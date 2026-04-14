module top_module(
    input CLK,
    output reg [7:0] D = 8'b00000000,
	 input RD,
    input RST,
    input RX,
    output reg RXNE = 1'b0
    );parameter CLOCK = 1_000_000;
parameter BAUD_RATE = 9_600;


localparam SAMPLES = 4;
localparam CLK_DIV = CLOCK/(BAUD_RATE*SAMPLES*2);
reg [$clog2(CLK_DIV)-1:0]baud_counter = 0;

reg prev_CLK_B;
reg CLK_B = 1'b0; 


always @ (posedge CLK) begin 
	prev_CLK_B <= CLK_B;
	baud_counter <= baud_counter+1'b1;
	if ( baud_counter == CLK_DIV-1) begin
		baud_counter <=0; 
		CLK_B <= ~CLK_B;
	end
end

reg [SAMPLES-1:0]symbol = {SAMPLES{1'b1}};
reg [$clog2(SAMPLES)-1:0]symbol_cnt = 0;

reg busy = 1'b0;
reg [9:0]data = 10'b1111111111;
reg [3:0]data_cnt = 0;
wire data_correct = (!data[0]) & data[9]; 


always @(posedge CLK) begin
	if (RST == 1'b1) begin
		symbol_cnt <= 0; 
		data_cnt <= 0;
		RXNE <= 1'b0;
		busy <= 1'b0;
		D <= 8'b00000000;
	end
	else if(CLK_B == 1'b1 && prev_CLK_B == 1'b0) begin 
		if((RX==1'b0) && (symbol[SAMPLES-1]==1'b0) && !data_cnt && !busy) begin
			symbol_cnt <= 2; 
			data_cnt <= 9;
			busy <= 1'b1;
		end
		
		if(busy) begin
			if(symbol_cnt) begin
				symbol_cnt <= symbol_cnt - 1'b1;
			end else begin
				case (symbol[SAMPLES-2:0])
					3'b111, 3'b110, 3'b101, 3'b011:
						data = {1'b1, data[9:1]}; 
					default:
						data = {1'b0, data[9:1]};
				endcase
				
				if (data_cnt) begin
					data_cnt <= data_cnt - 1'b1;
					symbol_cnt <= 3;
				end
				else begin 
					D <= data[8:1];
					RXNE <= 1'b1;
					busy <= 1'b0;
				end
			end
		end
		
		symbol <= {RX, symbol[SAMPLES-1:1]};
	end
	
	if (RD == 1'b1) begin
		RXNE <= 1'b0;
	end else begin
	end
end

endmodule