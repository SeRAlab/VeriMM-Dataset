module top_module(
	input CLK,
	input [7:0]D,
	input WR,
	input RST,
	output TX,
	output reg TXE = 1'b1
   );parameter CLOCK = 1_000_000;
parameter BAUD_RATE = 9_600;

localparam CLK_DIV = CLOCK/(BAUD_RATE*2);
reg [$clog2(CLK_DIV)-1:0]baud_counter = 0;

reg prev_CLK_B;
reg CLK_B = 1'b0; 

reg [9:0]send_reg = 10'h3FF;
reg [3:0]counter = 0;

assign TX = send_reg[0]; 


always @ (posedge CLK) begin 
	prev_CLK_B <= CLK_B;
	baud_counter <= baud_counter+1'b1;
	if ( baud_counter == CLK_DIV-1) begin
		baud_counter <=0; 
		CLK_B <= ~CLK_B;
	end
end


always @(posedge CLK) begin
	if (RST == 1'b1) begin
		send_reg <= 10'h3FF;
		counter <= 0;
		TXE <= 1'b1;
	end
	else if (WR == 1'b1 && TXE) begin
		send_reg <= {D, 1'b0, 1'b1};
		counter <= 10;
		TXE <= 1'b0;
	end
	else if(CLK_B == 1'b1 && prev_CLK_B == 1'b0) begin
		send_reg <= {1'b1, send_reg[9:1]};
		if(counter > 0) begin
			counter <= counter - 1'b1;
		end else begin
			TXE <= 1'b1;
		end
	end
end

endmodule