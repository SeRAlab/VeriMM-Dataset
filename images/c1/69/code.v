module uart_tx (input clk, input [7:0] prescaler, input [7:0] tx_in, input strobe, output reg txd, output busy, output prefetch);
parameter TX_STATE_IDLE = 0;
parameter TX_STATE_TRANSMIT = 1;
reg state = TX_STATE_IDLE;
reg [7:0] count = 0;
reg [7:0] scaler_counter = 0;
reg [7:0] dataout = 0;
parameter count_step = 2;
assign busy = state; 
wire scaler_limit = (scaler_counter==0);
wire bit_limit = (count[3:0] == 4'b0000);
wire last_bit = (count[7:4]==4'd10);
assign prefetch = ( state==TX_STATE_TRANSMIT ) & scaler_limit & bit_limit & last_bit;
always @(posedge clk) begin
	if ( state==TX_STATE_IDLE && strobe ) begin
		state <= TX_STATE_TRANSMIT;
		txd <= 0;
		count <= count_step;
		dataout <= tx_in;
		scaler_counter <= prescaler;
	end else if ( state==TX_STATE_TRANSMIT && scaler_limit ) begin
		if ( bit_limit ) begin
			if ( last_bit ) begin
				if ( strobe ) begin
					txd <= 0;
					count <= count_step;
					dataout <= tx_in;
				end else begin
					txd <= 1;
					state <= TX_STATE_IDLE;
				end
			end else begin
				txd <= dataout[0];
				dataout <= { 1'b1, dataout[7:1] };
				count <= count + count_step;
			end
		end else begin
			count <= count + count_step;
		end 
		scaler_counter <= prescaler;
	end else if ( state==TX_STATE_TRANSMIT ) begin
		scaler_counter <= scaler_counter - 1;
	end
end
endmodule